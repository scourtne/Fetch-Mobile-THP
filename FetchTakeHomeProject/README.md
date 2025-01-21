### Summary: Include screen shots or a video of your app highlighting its features

Implementation of the [Fetch Mobile Take Home Project](https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html)

![Preview Video](./Readme%20Contents/Preview.gif?raw=true)

Test Coverage: 

![Test coverage screenshot](./Readme%20Contents/Test%20Coverage.png?raw=true "Test coverage screenshot")

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I prioritized the UI and Image Caching, as these are both areas I've had little direct professional experience in. All the professional projects I've worked on have been almost entirely UIKit due to having started that way, with the little SwiftUI coming in only for brand new and isolated areas. That lack of professional experience leaves me relying on personal projects and learning, which means I've had little opportunity for learning from developers I can speak to directly. As for the caching, all projects I've worked on lean on either built-in support, internal libraries, or trusted third party libraries. There's a great deal of things that need to be considered for caching, enough to make it a substantial project on its own in an ideal world (for example, which eviction strategies to use, decisions around cache limits and usage, etc). Even when I've worked with APIs that manipulate images (sizing, scaling, etc) we've been able to largely lean on the libraries involved to handle caching strategies.

I spent less time on the API and associated models, as that's an area I'm very comfortable working with. While normally I'd be leaning on some level of additional framework, there's not too much complexity here (outside of error handling, such as authentication or network issues, and that can get involved enough that it's really out of scope of this sort of project).

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

- API/Models: 30 minutes
- UI: 2 hours
- Images: 1 hour
- Unit Tests:
- Readme: 45 min

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

#### API Decisions

- Utilize Codable for the model to greatly simplify decoding results. This has the downside of making it more involved to maintain version compatibility going forward, but in an ideal world API and App releases would be in sync, making this a manageable issue. This is an obvious choice for a quick one-off project.
    - Used the snake case key decoding strategy instead of manually creating the CodingKeys. I could see this being done either way, and while it's convenient to have the information live with the models, in this case I prefer having it one file (two if including tests)
- Separating the API model and a UI variant of the model. Normally this is something I'd be more inclined to do if there is common formatting occuring - for example, if there was a timestamp field being converted to a Date, or if I was converting the URLs before the UI view models could see them. Here it mostly just provides a convenient place to implement Identifiable for the sections, and to actually split up the sections by cuisine outside the view.
- Only using the small image, and even then using a constant size. I chose to do this because the larger images are just too much for a nice list view. Ideally I'd use those images for a nested page (for example, if the source url was to return the actual recipe, and we wanted to have a page with image/recipe/youtube player or something). Conveniently this also makes there be less cached images, although the downside is images are potentially larger than needed

#### UI Decisions

- Added a static delay in the reload logic in the viewmodel. This isn't something I'd want in production, but it's convenient for a demonstration app such as this.
- Leaving an empty state view that takes in a timestamp for the model. At one point this was used to display a more involved message (which is commented out for reference), but I moved to a common footer for all three states  (success/empty/error). I've left parts of this in place purely as an illustrative thing. For a production app I'd likely want additional views here - maybe a static "oops" image for example
- Using a toolbar as a footer. In order to help show that a fetch is actually properly occuring given the API response is static, I chose to provide a common timestamp. In order to not force scrolling to the bottom of the list constantly I decided to make it a footer, and a toolbar is a convenient way to have it not be associated with a particular list section
- Chose to leave old recipes in place while a refresh is happening. It makes the UI look a little nicer when there aren't changes, though there is likely animation work that would be necessary with non-static endpoint data
- Opening the URLs directly. It seems list, when it sees two Links (or Buttons etc) in one row view doesn't properly route the touches. Manually setting up a tap gesture recognizer allows for them to be used. I'm sure there are other, better solutions, but the other option I'd prefer right now would violate the single screen requirement.

#### Image Caching Decisions

- Taking advantage of NSCache for this, so I don't have to reimplement a substantial amount of logic. The amount of time to implement a proper, complete caching solution in place when there is anything available to lean on would be substantial.
- Added an image specific API fetcher. This let's the caching be completely hidden from any other layer.
    - Did not account for the possibility of fetching multiples of the same image. It _shouldn't_ happen assuming recipes are uniqued server side, but it would theoretically be possible (possibly for a placeholder value). For this case it wasn't worth the added complexity
    - Did not do any image scaling/resizing before saving them. If the same images were used at separate sizes, or given they're being explicitly resized before use, it would be convenient to be able to save the appropriate scaled variants as well/instead. I chose not to do that due to the substantial additional complexity involved.
- More generally, for this I'd rather use AsyncImage instead and completely avoid handling any of the caching logic myself. Since it's a requirement for this I can't do that, but the built-in would be preferred (and easier to work with)
    - Admittedly in some restricted environments the lack of ability to manipulate the caching process would be a problem, but this would still have ideally been my first solution

#### Testing Decisions

- Largely skipped API testing. While ideally this would be covered, normally I'd do so via mocks/stubbing with pre-existing frameworks for unit tests, and with mock or recorded data for UI tests. Given the requirement to avoid external frameworks that's a lot of work for a small test area that can be validated manually.
    - Note I do still want to test the actual model logic, to make sure they decode (or not) appropriately
- Removed the UI tests. They aren't required and add extra complexity, especially for what is essentially a one screen app (mainly since mocking endpoints would be a huge pain for this)
- Testing the ImageFetcher leans on URLs. I don't like doing this, but it isn't conveniently testable as designed otherwise

### Weakest Part of the Project: What do you think is the weakest part of your project?

Generally the actual SwiftUI usage. I'm certain there are better and cleaner ways of doing some of what I've created.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
