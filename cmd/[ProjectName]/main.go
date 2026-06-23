package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/knowfreedom/[project-name]/internal/common/config"
	"github.com/knowfreedom/[project-name]/internal/common/middleware"
	"github.com/knowfreedom/[project-name]/internal/features/health"
	"github.com/knowfreedom/[project-name]/internal/infrastructure/database"
)

func main() {
	cfg := config.Load()

	db, err := database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("database connection failed: %v", err)
	}

	r := gin.New()
	r.Use(middleware.Logger())
	r.Use(gin.Recovery())

	health.RegisterRoutes(r, db)

	log.Printf("starting %s on :%s", cfg.AppName, cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("server error: %v", err)
	}
}
