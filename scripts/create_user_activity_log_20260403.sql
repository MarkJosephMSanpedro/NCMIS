CREATE TABLE IF NOT EXISTS user_activity_log (
    log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NULL,
    username VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    action VARCHAR(120) NOT NULL,
    module VARCHAR(120) DEFAULT NULL,
    details TEXT DEFAULT NULL,
    http_method VARCHAR(10) DEFAULT NULL,
    route VARCHAR(255) DEFAULT NULL,
    ip_address VARCHAR(45) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id),
    KEY idx_user_activity_created_at (created_at),
    KEY idx_user_activity_role (role),
    KEY idx_user_activity_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
