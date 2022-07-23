package isuports

import "sync"

type cacheSliceCompetition struct {
	// Setが多いならsync.Mutex
	sync.RWMutex
	items map[string]CompetitionRow
}

func NewCompetitionCacheSlice() *cacheSliceCompetition {
	m := make(map[string]CompetitionRow)
	c := &cacheSliceCompetition{
		items: m,
	}
	return c
}

func (c *cacheSliceCompetition) Set(key string, value CompetitionRow) {
	c.Lock()
	c.items[key] = value
	c.Unlock()
}

func (c *cacheSliceCompetition) Get(key string) (CompetitionRow, bool) {
	c.RLock()
	v, found := c.items[key]
	c.RUnlock()
	return v, found
}

func (c *cacheSliceCompetition) Delete(key string) bool {
	c.Lock()
	delete(c.items, key)
	c.Unlock()
	return true
}
