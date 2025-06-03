<script type="text/javascript">
        var gk_isXlsx = false;
        var gk_xlsxFileLookup = {};
        var gk_fileData = {};
        function filledCell(cell) {
          return cell !== '' && cell != null;
        }
        function loadFileData(filename) {
        if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
            try {
                var workbook = XLSX.read(gk_fileData[filename], { type: 'base64' });
                var firstSheetName = workbook.SheetNames[0];
                var worksheet = workbook.Sheets[firstSheetName];

                // Convert sheet to JSON to filter blank rows
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                // Filter out blank rows (rows where all cells are empty, null, or undefined)
                var filteredData = jsonData.filter(row => row.some(filledCell));

                // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
                var headerRowIndex = filteredData.findIndex((row, index) =>
                  row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                // Fallback
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                  headerRowIndex = 0;
                }

                // Convert filtered JSON back to CSV
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex)); // Create a new sheet from filtered array of arrays
                csv = XLSX.utils.sheet_to_csv(csv, { header: 1 });
                return csv;
            } catch (e) {
                console.error(e);
                return "";
            }
        }
        return gk_fileData[filename] || "";
        }
        </script><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Calculator</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
            transition: background 0.3s ease;
        }
        .light-mode {
            background: linear-gradient(135deg, #a1c4fd, #c2e9fb);
        }
        .dark-mode {
            background: linear-gradient(135deg, #2c3e50, #4a69bd);
            color: #e0e0e0;
        }
        .calculator-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
            transition: background 0.3s ease, transform 0.3s ease;
            z-index: 1;
        }
        .dark-mode .calculator-container {
            background: rgba(30, 30, 30, 0.95);
        }
        .calculator-container:hover {
            transform: translateY(-5px);
        }
        h2 {
            background: linear-gradient(to right, #ff6b6b, #4ecdc4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .input-group i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
        }
        .input-group input, .input-group select {
            padding-left: 2.5rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .input-group input:focus, .input-group select:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 10px rgba(255, 107, 107, 0.3);
            outline: none;
        }
        .btn {
            position: relative;
            overflow: hidden;
            background: linear-gradient(to right, #ff6b6b, #4ecdc4);
            color: white;
            font-weight: 600;
            padding: 0.75rem;
            border-radius: 0.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }
        .btn:active {
            transform: scale(0.95);
        }
        .ripple {
            position: absolute;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
        }
        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        .mode-toggle {
            position: absolute;
            top: 1rem;
            right: 1rem;
            cursor: pointer;
            z-index: 2;
        }
        .result, .error {
            font-size: 1rem;
            text-align: center;
            animation: fadeIn 0.5s ease;
        }
        .result {
            color: #1f2937;
        }
        .dark-mode .result {
            color: #e0e0e0;
        }
        .error {
            color: #dc2626;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .snowflake {
            position: absolute;
            background: rgba(255, 255, 255, 0.8);
            width: 4px;
            height: 4px;
            border-radius: 50%;
            animation: fall linear infinite;
            z-index: 0;
        }
        .light-mode .snowflake {
            background: rgba(255, 255, 255, 0.6);
        }
        .dark-mode .snowflake {
            background: rgba(255, 255, 255, 0.9);
        }
        @keyframes fall {
            0% {
                transform: translate(0, -100vh) rotate(45deg);
                opacity: 1;
            }
            100% {
                transform: translate(100vw, 100vh) rotate(45deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body class="light-mode">
    <div class="mode-toggle">
        <i class="fas fa-moon text-2xl" id="theme-toggle"></i>
    </div>
    <div class="calculator-container">
        <h2 class="text-3xl font-bold text-center mb-6">Simple Calculator</h2>
        <form action="CalculatorServlet" method="post" onsubmit="return validateForm()">
            <div class="input-group">
                <i class="fas fa-calculator"></i>
                <input type="number" id="num1" name="num1" step="any" placeholder="First Number" required class="w-full p-3">
            </div>
            <div class="input-group">
                <i class="fas fa-calculator"></i>
                <input type="number" id="num2" name="num2" step="any" placeholder="Second Number" required class="w-full p-3">
            </div>
            <div class="input-group">
                <i class="fas fa-cog"></i>
                <select id="operation" name="operation" required class="w-full p-3">
                    <option value="" disabled selected>Select Operation</option>
                    <option value="add">Add</option>
                    <option value="subtract">Subtract</option>
                    <option value="multiply">Multiply</option>
                    <option value="divide">Divide</option>
                </select>
            </div>
            <button type="submit" class="btn w-full">Calculate</button>
        </form>
        <% if (request.getAttribute("result") != null) { %>
            <p class="result mt-4">Result: <%= request.getAttribute("result") %></p>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error mt-4"><%= request.getAttribute("error") %></p>
        <% } %>
    </div>
    <script>
        const toggle = document.getElementById('theme-toggle');
        const body = document.body;
        toggle.addEventListener('click', () => {
            body.classList.toggle('light-mode');
            body.classList.toggle('dark-mode');
            toggle.classList.toggle('fa-moon');
            toggle.classList.toggle('fa-sun');
        });
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                ripple.classList.add('ripple');
                const rect = button.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = e.clientX - rect.left - size / 2 + 'px';
                ripple.style.top = e.clientY - rect.top - size / 2 + 'px';
                button.appendChild(ripple);
                setTimeout(() => ripple.remove(), 600);
            });
        });
        function validateForm() {
            const operation = document.getElementById('operation').value;
            const num2 = document.getElementById('num2').value;
            if (operation === 'divide' && parseFloat(num2) === 0) {
                alert('Cannot divide by zero.');
                return false;
            }
            return true;
        }
        // Snowy drizzle effect
        function createSnowflake() {
            const snowflake = document.createElement('div');
            snowflake.classList.add('snowflake');
            snowflake.style.left = Math.random() * 100 + 'vw';
            snowflake.style.animationDuration = Math.random() * 3 + 2 + 's';
            snowflake.style.animationDelay = Math.random() * 5 + 's';
            document.body.appendChild(snowflake);
            setTimeout(() => snowflake.remove(), 5000);
        }
        setInterval(createSnowflake, 200);
    </script>
</body>
</html>