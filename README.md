### Project Report: TodoApp CLI Tool

#### 1. Overview

The **TodoApp CLI** is a lightweight, Swift-based command-line interface designed for efficient task management. It utilizes a protocol-oriented architecture to handle data persistence, allowing users to switch between memory-based storage for testing and file-based storage for persistent data.

#### 2. Technical Architecture

The application is built on three main components to ensure modularity and maintainability:

* **Data Models**: The `Todo` struct implements `Codable` and `CustomStringConvertible`, providing a standardized way to represent and format tasks.
* **Persistence Layer**: The `Cache` protocol defines the contract for saving and loading data. Current implementations include `InMemoryCache` for volatile storage and `FileSystemCache` for storing tasks in a local `todos.json` file.
* **Manager & CLI Logic**: The `TodosManager` class handles business logic, including adding, listing, toggling, and deleting tasks. The `App` class serves as the entry point, processing user input via a `while` loop and mapping commands to the manager.

#### 3. Current Implementation Status

* **File Persistence**: The application is configured to save task data to `todos.json`. By using `FileManager.default.currentDirectoryPath`, the file is now targeted at the project's working directory, ensuring easier access and version control.
* **Command Set**: Supports the following operations:
* `add [title]`: Creates a new task.
* `list`: Displays all current tasks with completion status.
* `toggle [index]`: Switches the completion state of a specific task.
* `delete [index]`: Removes a task from the list.
* `exit`: Terminates the CLI session.



#### 4. Acknowledgements

I would like to acknowledge the use of modern AI-powered developer tools throughout the creation of this project. These tools significantly enhanced my learning experience by acting as a collaborative pair-programmer. They provided invaluable assistance in refining Swift syntax, troubleshooting logic errors, and perfecting the code structure and documentation, ultimately enabling a more efficient and rigorous development workflow.

#### 5. Conclusion

This project provided hands-on experience with Swift's `Codable` protocol for JSON handling, as well as experience with protocol-oriented programming. It serves as a solid foundation for more complex CLI tools and demonstrates my ability to troubleshoot environment-specific issues like file pathing and remote repository authentication.

