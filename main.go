package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/avamsi/eclipse"
)

type Dotfiles struct{}

func (Dotfiles) Link() error {
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
			if !strings.HasPrefix(rel, ".") || strings.HasPrefix(rel, ".git") || strings.HasPrefix(rel, ".jj") {
				return filepath.SkipDir
			}
		} else if strings.HasPrefix(rel, ".") {
			symlink := filepath.Join(home, rel)
			if err := os.MkdirAll(filepath.Dir(symlink), 0755); err != nil {
				return err
			}
			if err := os.Symlink(path, symlink); err != nil {
				if errors.Is(err, fs.ErrExist) {
					fmt.Printf("Skipped %s;\n\t%v\n", path, err)
					return nil
				}
				return err
			}
			fmt.Printf("Symlinked %s to %s", path, symlink)
		}
		return nil
	})
}

func main() {
	eclipse.Execute(Dotfiles{})
}
