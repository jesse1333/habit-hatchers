# Habit Hatchers

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/c9ba4cdf-234c-4bf0-b9d6-c50d56c54ba9" alt="HabitHatchers Demo" width="300"/></td>
    <td>
      Habit Hatchers is a fun, interactive habit-tracking app where you collect "eggs" by completing daily habits. 
      As you collect more eggs, your chicken gets happier, helping you stay motivated to keep track of your progress. 
      Perfect for users who want to gamify their habit-building journey!
    </td>
  </tr>
</table>


https://github.com/user-attachments/assets/f40774dc-74fa-41ab-aabc-8487a2a0c932





https://github.com/user-attachments/assets/59fc5e16-688f-4629-9022-205983a09f85



## How It's Made:

**Tech used:** Swift, SwiftUI, XCode, Figma

I built this app using Swift and SwiftUI within the Xcode IDE. I began by designing the UI/UX in Figma:
<img width="855" alt="Screenshot 2024-11-14 at 3 46 18 PM" src="https://github.com/user-attachments/assets/f3804a8f-d53f-49ef-87c3-7797b65d95e3">

I then implemented this design in Swift, managing key elements such as view transitions, user inputs, and iPhone notifications. Testing was conducted thoroughly by deploying the app on my own iPhone through Xcode, allowing me to fine-tune the user experience.

<img width="1512" alt="Screenshot 2024-11-14 at 3 49 02 PM" src="https://github.com/user-attachments/assets/01bcd549-3976-493a-9e89-81f7528a8901">


Current features of the app include:

- **Adding Habit Eggs**: Users can add habits in the form of "eggs," which align with the app's playful theme.
- **Pop-Up Modals**: Easy-to-access pop-ups display a list of all habits, providing a quick overview for users.
- **Habit Metadata Tracking**: The app records essential habit data, such as total habits collected, streaks, creation date, and deletion date.
- **Habit Deletion and Recovery**: Users can delete habits, but they also have the option to recover them, offering flexibility in habit management.
- **Persistent Habit Storage**: Habit data is stored in JSON format, ensuring that progress is maintained across app sessions.
- **System Notification Reminders**: Reminders can be set, prompting users when it's time to complete or check in on their habits.







## Optimizations

To enhance both performance and maintainability, I implemented several optimizations:

Persistent File Storage with JSON: Given the small data requirements and offline functionality of the app, I opted for a JSON-based file storage system instead of a traditional database. This decision keeps the app lightweight and fast, while providing easy data retrieval and persistence across sessions instead of the alternative of using a database.

Object-Oriented Programming Principles: I structured the codebase around OOP principles, creating reusable classes and modular components. By encapsulating functionality into specific classes (such as handlers, views, and utility functions), I achieved a more organized, scalable code structure. This modular approach not only makes the code easier to read/maintain but also allows for easier enhancements and improvements in the future.

Efficient View Management: By separating different views and handling their updates with optimized functions, I minimized the workload on the main UI thread, making the application more smooth and interactive for the user.

## Lessons Learned:

This project was a valuable learning experience! By making this project, I...

- deepened my understanding of object-oriented programming by learning how to encapsulate classes effectively. This reinforced the importance of clean, modular code, allowing me to create a more organized and maintainable project structure.

- gained practical experience with JSON file storage, learning how data is structured within JSON to facilitate efficient storage and retrieval. This was a great introduction to handling persistent data without a traditional database.

- learned about the apple programming ecosystem (including Swift, SwiftUI, and XCode) which taught me a lot about how different views work in tandem with data and how said data flows throughout Swift, granting me a better understanding of the pros/cons of SwiftUI's reactive framework when compared to other frameworks like React.

- obtained an understanding of basic UI/UX design, using Figma to prototype a clean and responsive interface. This process taught me about design principles that contribute to an intuitive user experience, such as layout organization, color harmony, and responsive design.
