package usecases_test

import (
	"testing"

	"github.com/marechal-dev/Closely/internal/application/usecases"
	"github.com/marechal-dev/Closely/internal/domain/dtos"
	repositories_test "github.com/marechal-dev/Closely/test/domain/repositories"
	"github.com/stretchr/testify/assert"
)

func TestCreateStore(t *testing.T) {
	inMemoryStoresRepository := repositories_test.NewInMemoryStoresRepository()

	store, err := usecases.CreateStore(
		inMemoryStoresRepository,
		&dtos.StoreInput{
			Title:         "Lojinha do Bairro",
			LegalEntityID: "53721661000172",
		},
	)

	assert.NotNil(t, store)
	assert.Nil(t, err)
}

func TestTryCreateAlreadyExistentStore(t *testing.T) {
	inMemoryStoresRepository := repositories_test.NewInMemoryStoresRepository()

	store, _ := usecases.CreateStore(
		inMemoryStoresRepository,
		&dtos.StoreInput{
			Title:         "Lojinha do Bairro",
			LegalEntityID: "53721661000172",
		},
	)

	assert.NotNil(t, store)

	existentStore, err := usecases.CreateStore(
		inMemoryStoresRepository,
		&dtos.StoreInput{
			Title:         "Lojinha do Bairro",
			LegalEntityID: "53721661000172",
		},
	)

	assert.Nil(t, existentStore)
	assert.NotNil(t, err)
	assert.EqualValues(t, err.Error(), "store already exists")
}
