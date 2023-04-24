package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/avamsi/clifr"
)

type Dotfiles struct {
	Force bool
}

func (dot Dotfiles) symlink(oldname, newname string) error {
	err := os.Symlink(oldname, newname)
	if errors.Is(err, fs.ErrExist) && dot.Force {
		fmt.Printf("%s already exists, attempting to symlink anyway (--force)\n", newname)
		if err = os.Remove(newname); err == nil { // if _no_ error
			err = os.Symlink(oldname, newname)
		}
	}
	return err
}

func (dot Dotfiles) Link() error {
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
			if err := dot.symlink(path, symlink); err != nil {
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

func main() {
	clifr.Execute(Dotfiles{})
}
