package repositories_test

import (
	"slices"

	"github.com/marechal-dev/Closely/internal/domain/entities"
)

type InMemoryStoresRepository struct {
	Stores []*entities.Store
}

func NewInMemoryStoresRepository() *InMemoryStoresRepository {
	return &InMemoryStoresRepository{}
}

func (repo *InMemoryStoresRepository) Create(store *entities.Store) error {
	repo.Stores = append(repo.Stores, store)

	return nil
}

func (repo *InMemoryStoresRepository) FindOneByLegalEntityID(identifier string) *entities.Store {
	idx := slices.IndexFunc(repo.Stores, func(s *entities.Store) bool {
		return s.LegalEntityID == identifier
	})

	if idx == -1 {
		return nil
	}

	return repo.Stores[idx]
}
