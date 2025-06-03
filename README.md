# JavaServlet-Calculator
# Servlet Calculator Project (MyWebApp)

## Overview
The Servlet Calculator Project is a simple Java web application (`MyWebApp`) that allows users to perform basic arithmetic operations (addition, subtraction, multiplication, division) through a web interface. It also includes a login feature for user authentication. The application is built using Java Servlets, JSP (JavaServer Pages), and deployed on Apache Tomcat. It optionally integrates with a MySQL database for user authentication (`LoginServlet`), while the calculator functionality (`CalculatorServlet`) operates independently of the database.

This project demonstrates:
- Servlet and JSP integration for dynamic web content.
- Form handling and request processing in a web application.
- Deployment on Apache Tomcat.
- Basic styling with CSS and client-side JavaScript for interactivity.

**Date Created**: June 03, 2025  
**Environment**: Windows 10, Apache Tomcat 9.x, JDK 21, MySQL 8.0.33

---

## Project Structure
The project is located at `D:\tekey\Apache Software Foundation2\webapps\MyWebApp\`. Below is the detailed directory structure:
D:\tekey\Apache Software Foundation2\webapps\MyWebApp\
├── Login.jsp
├── Calculator.jsp
├── WEB-INF/
│   ├── web.xml
│   ├── classes/
│   │   ├── LoginServlet.class
│   │   ├── CalculatorServlet.class


---

## Prerequisites
Before setting up the project, ensure the following are installed on your Windows 10 machine:

1. **JDK 21**:
   - Installed at `D:\tekey\JDK21`.
   - Set `JAVA_HOME` environment variable to `D:\tekey\JDK21` (see Setup section).

2. **Apache Tomcat**:
   - Installed at `D:\tekey\Apache Software Foundation2`.
   - Recommended version: Tomcat 9.x (e.g., 9.0.93) for compatibility with `javax.servlet` APIs.
   - Tomcat 10.x uses `jakarta.servlet`, which requires code changes.

3. **MySQL (Optional)**:
   - Installed at `D:\tekey\MySQL`.
   - Version: 8.0.33.
   - Required if `LoginServlet` uses the database (`mysql_inventory_db`).
   - MySQL service name: `MySQL80` (or as configured).

4. **MySQL Connector/J**:
   - `mysql-connector-java-8.0.33.jar` must be in `WEB-INF\lib\`.

5. **Browser**:
   - Any modern browser (e.g., Chrome, Firefox) to access the web app.

---

## Setup Instructions

### 1. Configure Environment Variables
- Set `JAVA_HOME` to point to JDK 21:
  1. Right-click Start > `System` > `Advanced system settings` > `Environment Variables`.
  2. Under "System variables," click `New`:
     - Variable name: `JAVA_HOME`
     - Variable value: `D:\tekey\JDK21`
  3. Edit `Path` variable, add: `%JAVA_HOME%\bin`.
  4. - Tomcat auto-deploys the app when started.

### 4. Start Tomcat
- Open Command Prompt:
- A new window opens with Tomcat logs. Look for:
- Verify Tomcat is running:
- Open browser: `http://localhost:8080`.
- Expected: Tomcat welcome page.

### 5. Access the Application
- Access the calculator:http://localhost:8080/MyWebApp/Calculator.jsp
- Access the login page (if applicable):http://localhost:8080/MyWebApp/Login.jsp


---

## Usage

### Calculator Feature (`Calculator.jsp` and `CalculatorServlet`)
1. Navigate to `http://localhost:8080/MyWebApp/Calculator.jsp`.
2. The page displays a form with:
 - Two input fields for numbers (`num1`, `num2`).
 - A dropdown to select the operation (Add, Subtract, Multiply, Divide).
 - A "Calculate" button.
3. Enter two numbers, select an operation, and click "Calculate".
4. The form submits to `CalculatorServlet`, which:
 - Processes the inputs.
 - Performs the selected operation.
 - Returns the result to `Calculator.jsp` for display.
5. Example:
 - Input: `num1 = 5`, `num2 = 3`, Operation: Add.
 - Output: `Result: 8`.

### Login Feature (`Login.jsp` and `LoginServlet`) (Optional)
- If implemented with database integration:
1. Navigate to `http://localhost:8080/MyWebApp/Login.jsp`.
2. Enter username and password.
3. Submit the form to `LoginServlet`.
4. `LoginServlet` validates credentials against `mysql_inventory_db` (e.g., `employees` table).
5. On success, redirects to a welcome page or `Calculator.jsp`.

---

## Key Files

- **Calculator.jsp**:
- Front-end for the calculator.
- Contains a form that submits to `CalculatorServlet`.

- **CalculatorServlet.class**:
- Handles calculator logic.
- Processes form data, performs arithmetic, and forwards the result back to `Calculator.jsp`.

- **Login.jsp** (Optional):
- Front-end for user login.
- Submits to `LoginServlet`.

- **LoginServlet.class** (Optional):
- Handles login logic.
- Connects to `mysql_inventory_db` for authentication.

- **web.xml**:
- Configures servlet mappings:
  ```xml
  <servlet>
      <servlet-name>CalculatorServlet</servlet-name>
      <servlet-class>CalculatorServlet</servlet-class>
  </servlet>
  <servlet-mapping>
      <servlet-name>CalculatorServlet</servlet-name>
      <url-pattern>/CalculatorServlet</url-pattern>
  </servlet-mapping>

