package middleware

import (
	"log"
	"time"

	"github.com/gin-gonic/gin"
)

// Logger logs method, path, status, and latency.
// Never logs headers or bodies — they may contain Authorization tokens or PII.
func Logger() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		path := c.Request.URL.Path

		c.Next()

		log.Printf("%s %s %d %s",
			c.Request.Method,
			path,
			c.Writer.Status(),
			time.Since(start),
		)
	}
}
