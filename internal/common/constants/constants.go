package constants

const (
	// Auth
	AuthorizationHeader = "Authorization"
	BearerPrefix        = "Bearer "
	ClaimUserID         = "user_id"

	// Context keys — use typed keys in production to avoid collisions
	CtxUserID = "ctx_user_id"
)
