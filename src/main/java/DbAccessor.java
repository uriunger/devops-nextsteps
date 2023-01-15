import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DbAccessor {

    // db is provisioned with a single table called access with this schema:
    // create table access (id int primary key auto_increment, time datetime not null);

    public static void logAccess() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = System.getenv("JDBC_URL");
        try (Connection con = DriverManager
                .getConnection(url, "uri", "TopSecret#0")) {

            con.setAutoCommit(false);

            try (Statement stmt = con.createStatement()) {

                String insertSql = "insert into access (time) values (current_timestamp)";
                stmt.executeUpdate(insertSql);

                con.commit();
                con.close();
            }
        }
    }
}
