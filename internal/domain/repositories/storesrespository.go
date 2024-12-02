package repositories

import "github.com/marechal-dev/Closely/internal/domain/entities"

type StoresRepository interface {
	Create(store *entities.Store) error
	FindOneByLegalEntityID(identifier string) *entities.Store
}
