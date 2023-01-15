import java.sql.*;

public class DbAccessor {


    public static void logAccess(String clientIpAddress) throws SQLException, ClassNotFoundException {

        // load jdbc driver for mysql
        Class.forName("com.mysql.cj.jdbc.Driver");

        // url for database should be set as ENV variable
        String url = System.getenv("JDBC_URL");

        try (Connection con = DriverManager
                .getConnection(url, "uri", "TopSecret#0")) {

            con.setAutoCommit(false);

            // automatically create schema if missing
            // db should be provisioned with a single table called 'access' with this schema:
            // create table access (id int primary key auto_increment, time datetime not null);
            try (Statement stmt = con.createStatement()) {
                String createTable = "create table access (" +
                        "id int primary key auto_increment, " +
                        "time datetime not null," +
                        "caller_ip string not null);";
                stmt.execute(createTable);
                con.commit();
            }

            String insertSql = "insert into access (time, caller_ip) values (current_timestamp, ?)";
            try (PreparedStatement stmt = con.prepareStatement(insertSql)) {
                stmt.setString(1, clientIpAddress);
                stmt.executeUpdate();
                con.commit();
                con.close();
            }
        }
    }
}
