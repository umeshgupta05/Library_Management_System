import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import javax.servlet.RequestDispatcher;

@WebServlet("/CheckLoginServlet")
public class CheckLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");

        // Simple validation - Replace with real validation as needed
        if ("admin".equals(userId) && "password123".equals(password)) {
            // Valid credentials, create session
            HttpSession session = request.getSession(true);
            session.setAttribute("username", userId);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Create cookie for persistent login
            Cookie userCookie = new Cookie("username", userId);
            userCookie.setMaxAge(30 * 60); // 30 minutes
            userCookie.setPath("/");
            response.addCookie(userCookie);
            
            // Redirect to welcome page
            response.sendRedirect("welcome.jsp");
        } else {
            // Invalid credentials, set error message and redirect to login.jsp
            request.setAttribute("errorMessage", "Invalid UserId or Password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
            dispatcher.forward(request, response);
        }
    }
}