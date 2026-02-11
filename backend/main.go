package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/javadshm/Texas-Hold-em-poker/backend/api"
)

// corsMiddleware adds CORS headers to all responses
func corsMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Allow all origins for development
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		// Handle preflight requests
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next(w, r)
	}
}

func main() {
	// Register API handlers with CORS
	http.HandleFunc("/api/evaluate", corsMiddleware(api.HandleEvaluate))
	http.HandleFunc("/api/compare", corsMiddleware(api.HandleCompare))
	http.HandleFunc("/api/montecarlo", corsMiddleware(api.HandleMonteCarlo))

	// Health check endpoint
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	port := "8080"
	fmt.Printf("Server starting on port %s...\n", port)
	fmt.Println("Available endpoints:")
	fmt.Println("  POST /api/evaluate")
	fmt.Println("  POST /api/compare")
	fmt.Println("  POST /api/montecarlo")
	fmt.Println("  GET  /health")

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
