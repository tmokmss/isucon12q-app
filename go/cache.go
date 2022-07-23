package isuports

import "sync"

type cacheSlice struct {
	// Setが多いならsync.Mutex
	sync.RWMutex
	items map[string]PlayerRow
}

func NewCacheSlice() *cacheSlice {
	m := make(map[string]PlayerRow)
	c := &cacheSlice{
		items: m,
	}
	return c
}

func (c *cacheSlice) Set(key string, value PlayerRow) {
	c.Lock()
	c.items[key] = value
	c.Unlock()
}

func (c *cacheSlice) Get(key string) (PlayerRow, bool) {
	c.RLock()
	v, found := c.items[key]
	c.RUnlock()
	return v, found
}
