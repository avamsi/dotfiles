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
	home, err := os.UserHomeDir()
	if err != nil {
		return err
	}
	df := filepath.Join(home, "dotfiles")
	return filepath.WalkDir(df, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(df, path)
		if err != nil {
			return err
		}
		if d.IsDir() {
			// We only want to symlink "dotfiles".
			if !strings.HasPrefix(rel, ".") {
				return filepath.SkipDir
			}
			if d.Name() == ".git" || d.Name() == ".jj" {
				return filepath.SkipDir
			}
			// We only want to symlink "dotfiles".
		} else if strings.HasPrefix(rel, ".") {
			// Skip dotfiles that are not related to actual dotfiles.
			if d.Name() == ".gitmodules" {
				return nil
			}
			// Manually skip .gitignore and its contents.
			if d.Name() == ".gitignore" || strings.HasSuffix(d.Name(), ".zsh.zwc") {
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
		}
		return nil
	})
}

//go:generate go run github.com/avamsi/climate/cmd/climate --out=md.climate
//go:embed md.climate
var md []byte

func main() {
	os.Exit(climate.Run(climate.Struct[dotfiles](), climate.Metadata(md)))
}
