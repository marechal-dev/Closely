package usecases

import (
	"errors"

	"github.com/marechal-dev/Closely/internal/domain/dtos"
	"github.com/marechal-dev/Closely/internal/domain/entities"
	"github.com/marechal-dev/Closely/internal/domain/repositories"
)

func CreateStore(
	storesRepository repositories.StoresRepository,
	input *dtos.StoreInput,
) (*entities.Store, error) {
	store := storesRepository.FindOneByLegalEntityID(input.LegalEntityID)

	if store != nil {
		return nil, errors.New("store already exists")
	}

	createdStore := entities.NewStore(input.Title, input.LegalEntityID)

	err := storesRepository.Create(createdStore)

	if err != nil {
		return nil, err
	}

	return createdStore, nil
}
