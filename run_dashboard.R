# ==============================================================================
# STUDENT PERFORMANCE ANALYSIS SYSTEM - APPLICATION LAUNCHER
# Runs the Shiny Web App and Opens it in your Default Web Browser
# ==============================================================================

# Ensure library path includes project-level libraries
local_lib <- "/Users/parassehgal/.gemini/antigravity/scratch/r_libs"
if (dir.exists(local_lib)) {
  .libPaths(c(local_lib, .libPaths()))
}

# Auto-install shiny if not present
if (!requireNamespace("shiny", quietly = TRUE)) {
  cat("Installing required 'shiny' package from CRAN...\n")
  install.packages("shiny", repos = "https://cloud.r-project.org")
}

library(shiny)

# Set working directory to this script's directory
current_dir <- getwd()
if (file.exists(file.path(current_dir, "app.R"))) {
  app_dir <- current_dir
} else if (file.exists("/Users/parassehgal/.gemini/antigravity/scratch/student_performance_analysis/app.R")) {
  app_dir <- "/Users/parassehgal/.gemini/antigravity/scratch/student_performance_analysis"
  setwd(app_dir)
} else {
  app_dir <- "."
}

cat("\n====================================================================\n")
cat(" 🎓 STUDENT PERFORMANCE ANALYSIS SYSTEM                           \n")
cat("====================================================================\n")
cat(" 🚀 Starting Web Application on Localhost...\n")
cat(" 🌐 Access URL    : http://127.0.0.1:5000\n")
cat(" 🔑 Demo Username : admin\n")
cat(" 🔒 Demo Password : admin123\n")
cat(" 🛑 Stop Server   : Press Ctrl+C in terminal\n")
cat("====================================================================\n\n")

# Run app and launch browser
shiny::runApp(
  appDir = app_dir,
  port = 5000,
  host = "127.0.0.1",
  launch.browser = TRUE
)
