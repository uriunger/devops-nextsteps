
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Simple Hello World servlet.
 */

public final class Hello extends HttpServlet {

    private static final long serialVersionUID = 1209661884251841348L;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println(":: in init");
    }

    /**
     * Respond to a GET request for the content produced by this servlet.
     *
     * @param request  The servlet request we are processing
     * @param response The servlet response we are producing
     * @throws IOException      if an input/output error occurs
     * @throws ServletException if a servlet error occurs
     */


    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        boolean success = true;
        try {
            DbAccessor.logAccess(getClientIpAddress(request));
        } catch (Exception e) {
            success = false;
            e.printStackTrace();
        }

        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("<html>");
        pw.println("<head>");
        pw.println("<title>Hello from a Servlet page</title>");
        pw.println("</head>");
        pw.println("<body bgcolor=white>");

        pw.println("<table border=\"0\" cellpadding=\"10\">");
        pw.println("<tr>");
        pw.println("<td>");
        pw.println("<img src=\"img/aplos.png\">");
        pw.println("</td>");
        pw.println("<td>");
        pw.println("<h1>Hello from a servlet page.</h1>");
        pw.println("success = " + success);
        pw.println("</td>");
        pw.println("</tr>");
        pw.println("</table>");

        pw.println("This is the output of a servlet");

        pw.println("</body>");
        pw.println("</html>");

        pw.close();

    }

    private static final String[] HEADERS_TO_TRY = {
            "X-Forwarded-For",
            "Proxy-Client-IP",
            "WL-Proxy-Client-IP",
            "HTTP_X_FORWARDED_FOR",
            "HTTP_X_FORWARDED",
            "HTTP_X_CLUSTER_CLIENT_IP",
            "HTTP_CLIENT_IP",
            "HTTP_FORWARDED_FOR",
            "HTTP_FORWARDED",
            "HTTP_VIA",
            "REMOTE_ADDR" };

    private String getClientIpAddress(HttpServletRequest request) {
        for (String header : HEADERS_TO_TRY) {
            String ip = request.getHeader(header);
            if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
                return ip;
            }
        }

        return request.getRemoteAddr();
    }

}
