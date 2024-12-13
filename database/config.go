package database

import (
	"context"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/twpayne/go-geos"
	pgxgeos "github.com/twpayne/pgx-geos"
)

func ConnectToDatabase(ctx context.Context, connString string) (*pgx.Conn, error) {
	conn, err := pgx.Connect(ctx, connString)
	if err != nil {
		return nil, err
	}

	config := conn.Config()

	config.AfterConnect = func(innerCtx context.Context, _ *pgconn.PgConn) error {
		if err := pgxgeos.Register(innerCtx, conn, geos.NewContext()); err != nil {
			return err
		}

		return nil
	}

	return conn, nil
}
