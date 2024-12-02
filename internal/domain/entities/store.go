package entities

import (
	"time"

	"github.com/google/uuid"
)

type Store struct {
	ID            string
	Title         string
	LegalEntityID string
	CreatedAt     time.Time
}

func NewStore(title string, legalEntityID string) *Store {
	return &Store{
		ID:            uuid.NewString(),
		Title:         title,
		LegalEntityID: legalEntityID,
		CreatedAt:     time.Now(),
	}
}
