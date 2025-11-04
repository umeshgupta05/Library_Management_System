package config;

/**
 * Database Configuration Class - TEMPLATE
 * Copy this file to DatabaseConfig.java and update with your credentials
 * DO NOT commit DatabaseConfig.java to version control
 */
public class DatabaseConfig_TEMPLATE {
    
    // Database connection parameters
    private static final String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USERNAME = "your_username_here";
    private static final String DB_PASSWORD = "your_password_here";
    
    /**
     * Get JDBC Driver class name
     * @return Driver class name
     */
    public static String getDriver() {
        return DB_DRIVER;
    }
    
    /**
     * Get database connection URL
     * @return Database URL
     */
    public static String getUrl() {
        return DB_URL;
    }
    
    /**
     * Get database username
     * @return Username
     */
    public static String getUsername() {
        return DB_USERNAME;
    }
    
    /**
     * Get database password
     * @return Password
     */
    public static String getPassword() {
        return DB_PASSWORD;
    }
}
