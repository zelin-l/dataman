package storagenode

import (
	"net/http"

	"github.com/jacksontj/dataman/metrics"
	"github.com/julienschmidt/httprouter"
)

func NewStorageNode(config *Config) (*StorageNode, error) {
	node := &StorageNode{
		Config:      config,
		Datasources: make(map[string]*DatasourceInstance),

		registry: metrics.NewNamespaceRegistry("storagenode"),
	}
	node.m = NewStorageNodeMetrics(node.registry)

	newRegistry := func() metrics.Collectable {
		return metrics.NewNamespaceRegistry("")
	}
	// Try adding a *similar* metric that won't conflict
	registryArray := &metrics.CollectableArray{
		Metric:    metrics.Metric{Name: "datasource_instance"},
		Creator:   newRegistry,
		LabelKeys: []string{"datasource_instance_name"},
	}
	node.registry.Register(registryArray)

	// TODO: error if no datasources?
	for datasourceName, datasourceConfig := range config.Datasources {
		datasourceConfig.Registry = registryArray.WithValues(datasourceName).(metrics.Registry)
		if datasource, err := NewDatasourceInstanceDefault(datasourceConfig); err == nil {
			node.Datasources[datasourceName] = datasource
		} else {
			return nil, err
		}
	}
	return node, nil
}

// This node is responsible for handling all of the queries for a specific storage node
// This is also responsible for maintaining schema, indexes, etc. from the metadata store
// and applying them to the actual storage subsystem
type StorageNode struct {
	Config *Config

	Datasources map[string]*DatasourceInstance

	registry metrics.Registry
	m        StorageNodeMetrics
}

// TODO: have a stop?
func (s *StorageNode) Start() error {
	// initialize the http api (since at this point we are ready to go!
	router := httprouter.New()
	api := NewHTTPApi(s)
	api.Start(router)

	return http.ListenAndServe(s.Config.HTTP.Addr, router)
}
