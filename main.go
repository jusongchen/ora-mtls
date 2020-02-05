package main

import (
	"fmt"
	"log"
	"os"

	//oracle db driver
	"database/sql"

	_ "gopkg.in/rana/ora.v4"
	// _ "github.com/godror/godror"
)

func main() {

	src := os.Getenv("DATA_SOURCE")
	if src == "" {
		log.Println("env DATA_SOURCE is not set")
		log.Printf("example data source:%s/%s@%s", "kite", "kite", "adhoc-db1-2-crd.eng.sfdc.net/slob")

		return
	}

	err := openDB(src)
	if err != nil {
		fmt.Printf("open DB failed:%v", err)
		return
	}
	fmt.Printf("made connection to %s succeeded\n", src)

}

func openDB(dataSource string) (err error) {

	db, err := sql.Open("ora", dataSource)
	if err != nil {
		return fmt.Errorf("Open DB %s failed:%w", dataSource, err)
	}

	err = db.Ping()
	if err != nil {
		return fmt.Errorf("Ping DB %s failed:%w", dataSource, err)
	}

	var username string
	stmt := "select user from dual"
	err = db.QueryRow(stmt).Scan(&username)

	if err != nil {
		return fmt.Errorf("%s failed:\n%w", stmt, err)
	}
	fmt.Printf("connected to %s, username:%s\n", dataSource, username)
	return nil
}
