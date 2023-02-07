package main

import (
	"fmt"
	"log"
	"os"

	"github.com/urfave/cli/v2"
)

func main() {
	app := &cli.App{
		Name:  "plow",
		Usage: "Plow manages your development environment using buildpacks",
		Action: func(*cli.Context) error {
			fmt.Println("hi!")
			return nil
		},
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
