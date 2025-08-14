package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	_ "embed"

	"github.com/avamsi/climate"
	ignore "github.com/sabhiram/go-gitignore"
)

type dotfiles struct{}

func link(oldname, newname string, force bool) error {
	err := os.Symlink(oldname, newname)
	if errors.Is(err, fs.ErrExist) && force {
		fmt.Printf("%s already exists, attempting to symlink anyway (--force)\n", newname)
		if err = os.Remove(newname); err == nil { // if _no_ error
			err = os.Symlink(oldname, newname)
		}
	}
	return err
}

type linkOptions struct {
	Force bool `climate:"short"` // override any existing files
}

// Link symlinks all dotfiles to the user's home directory.
func (*dotfiles) Link(opts *linkOptions) error {
	home, err1 := os.UserHomeDir()
	if err1 != nil {
		return err1
	}
	var (
		df       = filepath.Join(home, "dotfiles")
		gif      = filepath.Join(df, ".gitignore")
		gi, err2 = ignore.CompileIgnoreFile(gif)
	)
	if err2 != nil {
		if errors.Is(err2, fs.ErrNotExist) {
			gi = ignore.CompileIgnoreLines()
		} else {
			return err2
		}
	}
	return filepath.WalkDir(df, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(df, path)
		if err != nil {
			return err
		}
		// We only want to symlink "dotfiles".
		if !strings.HasPrefix(rel, ".") {
			if d.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}
		if d.IsDir() {
			if d.Name() == ".git" || d.Name() == ".jj" {
				return filepath.SkipDir
			}
			return nil
		}
		if d.Name() == ".gitmodules" || d.Name() == ".gitignore" {
			return nil
		}
		if skip, why := gi.MatchesPathHow(rel); skip {
			fmt.Printf("Skipped %s;\n\tmatched %s#L%d: %s\n", path, gif, why.LineNo, why.Line)
			return nil
		}
		symlink := filepath.Join(home, rel)
		if err := os.MkdirAll(filepath.Dir(symlink), 0755); err != nil {
			return err
		}
		if err := link(path, symlink, opts.Force); err != nil {
			if errors.Is(err, fs.ErrExist) {
				fmt.Printf("Skipped %s;\n\t%v\n", path, err)
				return nil
			}
			return err
		}
		fmt.Printf("Symlinked %s to %s\n", path, symlink)
		return nil
	})
}

//go:generate go tool cligen md.cli
//go:embed md.cli
var md []byte

func main() {
	climate.RunAndExit(climate.Struct[dotfiles](), climate.WithMetadata(md))
}
