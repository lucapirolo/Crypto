# Crypto.com Inspired App


Welcome to my iOS application project, crafted with inspiration from the acclaimed Crypto.com app. This project is a demonstration of my capabilities in iOS development, showcasing a blend of creativity, innovation in design, and practical functionality. While the app draws influence from Crypto.com, it is not a direct replication. Instead, I've infused my personal creative touch, resulting in a distinctive user interface that holds its own. This application stands as a testament to my proficiency in creating intuitive, visually appealing iOS applications, tailored to the dynamic realm of cryptocurrency.

----------

# Project Objectives

My primary goal was to replicate key screens from the Crypto.com application, with a focus on functionality and design accuracy. The primary areas of focus included:

1.  **Tracking Screen:** A pivotal feature, this screen displays data from the cryptocurrency market. My objective was to create a seamless and intuitive interface that allows users to effortlessly track market trends and fluctuations.
    
**Accounts Screen:** This screen is designed for users to view their account balance and cryptocurrency holdings. It's crafted to offer a clear, concise, and user-friendly interface that priorities readability and ease of navigation. The goal is to provide users with a comprehensive overview of their assets, ensuring they have instant access to their financial information.    

While I initially intended to include a feature replicating the card application process found in Crypto.com, app I encountered challenges with finding images high quality images of the Crypto.com cards that i could use in the application.

Throughout this project, my focus has been on delivering a functional, aesthetically pleasing, and user-centric application.


## Initial Design and UI Setup

In an effort to subtly mimic the UI of Crypto.com, I chose to replicate their colour scheme and typography. Fortunately, I discovered their style guide online, which was instrumental in this process. It enabled me to accurately add all their colour palettes into my Xcode project and identify the exact font they use. This valuable resource provided a solid foundation for creating a UI that resonates with the familiar aesthetic of Crypto.com. You can view the style guide here: [Crypto.com Arena Style Guide](https://www.cryptoarena.com/assets/doc/Crypto.com-Arena-Style-Guide_Nov.-2021-d4bb561fb8.pdf).

## Tracking Screen implementation 

To develop the tracking screen, access to cryptocurrency market data was essential. For this, I opted to utilise CoinGecko's free API, which conveniently offers access to some endpoints without the need for an API key. My choice was influenced by its simplicity and my previous experience with it, ensuring a smooth and efficient integration process.

In my implementation, I employed a base network manager that I routinely use across most of my Swift projects. While occasional minor adjustments are made based on specific project requirements, this base network manager is a cornerstone of my development process. It significantly minimises repetitive code when making network requests, thereby streamlining the development workflow and enhancing overall efficiency.

I aimed to showcase my proficiency with a fundamental Swift framework, CoreData, by utilising it as the persistence layer in my application. This decision enabled me to effectively store the cryptocurrency data retrieved from the server. Additionally, implementing CoreData not only demonstrates my technical capabilities but also enhances user experience by allowing access to historical market data even when offline.

For the user interface, I chose Swift UI due to my enthusiasm for delving deeper into this fantastic framework, which greatly simplifies reactive programming. Embracing the MVVM architecture, which is the norm with Swift UI, I leveraged Swift UI's features like ObservableObject, EnvironmentObjects, and more to build a responsive and efficient UI. 

While I have a strong affinity for Swift UI, I acknowledge that as a comparatively newer framework, it sometimes falls short of UIKit's stability and range of capabilities. In such instances, I employ UIViewRepresentable to seamlessly incorporate UIKit views within a Swift UI project, ensuring the best of both worlds in terms of functionality and design.
  
In this project, I aim to minimise reliance on third-party libraries, adhering to my overarching philosophy: whenever feasible, if a task can be accomplished without depending on external libraries within a reasonable timeframe and with a solid implementation, it's preferable to do so. This approach ensures greater control over the codebase, enhanced security, and reduces potential future compatibility issues. Consequently, when faced with the challenge of developing a chart view for the sparkline data, I was excited to utilise Swift UI's Native Charts, introduced in Swift UI 4 and iOS 16. Working with the Charts framework was a great experience, and I'm eager to delve deeper into its capabilities during my free time. 

## Crypto Detail Screen implementation

I designed a detailed view that activates when a user selects a cryptocurrency from the tracking screen. This page is intended to present key market data for the selected coin, including its market cap, trading volume, rank, and other relevant metrics. Additionally, I aimed to incorporate a section where users can manage and view their portfolio holdings. To facilitate this, I introduced an additional property to the CoreData entity, specifically for tracking the holdings amount.

## Accounts Screen implementation

To implement the account screen effectively, my objective was to retrieve all the user's holdings and rank them according to the most valuable assets. For this purpose, I utilized the `@FetchRequest` property in Swift UI, which enables direct data fetching from the CoreData instance. This approach is particularly efficient for simple queries, such as fetching all cryptocurrencies with holdings greater than zero. However, for more complex queries within CoreData, it's advisable to use a persistence controller. A significant advantage of `@FetchRequest` is that it allows the UI to automatically refresh whenever there are changes in the entity data, ensuring a dynamic and responsive user experience. 

I also planned to add an account balance feature at the top of the account page, similar to what is seen in the Crypto.com app, including a visibility toggle for enhanced security. To bring this to life, I needed to first fetch all the cryptocurrencies in which the user has holdings. Once this data was retrieved, I used a specific piece of code to calculate the total value of these holdings.

This calculation involved iterating through each cryptocurrency the user holds, multiplying the amount of each holding by its current market price. By summing these individual values, I was able to determine the total value of the user's portfolio.

## Conclusions And Potential Improvements 

Working on this concise project was a thoroughly enjoyable experience as it sparked my creativity in reimagining the UI and also provided an opportunity to learn about Swift UI's new Charts framework. The primary objective of this project is to offer readers a glimpse into my coding style and thought process as they review the code.

If given more time to enhance this project, my initial focus would be on integrating a WebSocket API to ensure real-time data updates, as the current setup doesn't provide this. Additionally, I would consider implementing pagination on the market data page to improve user experience and data handling. Another potential enhancement would be to add functionality for tracking the profits of each cryptocurrency holding. However, as the intent was to keep this project small and focused, these enhancements were not included in the initial scope.
