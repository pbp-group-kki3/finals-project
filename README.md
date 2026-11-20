# Spoonfed Mobile

Spoonfed helps users decide what to eat. Users can look up a packaged food, compare its nutrition with another product, discover a daily recipe, or plan meals around their dietary preferences. The app also includes articles about food and sustainability.

This repository contains the Flutter mobile app. The group’s Django website provides the data through a Django REST Framework API.

## Project Links

| Resource | Link |
|---|---|
| Flutter repository · Checkpoint 1 submission | [pbp-group-kki3/finals-project](https://github.com/pbp-group-kki3/finals-project) |
| Django backend repository | [pbp-group-kki3/midterm-project](https://github.com/pbp-group-kki3/midterm-project) |
| PWS deployment · API base URL | TBD |
| Figma design | TBD |
| APK · GitHub Release | TBD |
| Bitrise build | TBD |
| SCELE submission page | TBD |

## Group Members & Module Ownership

| Name | NPM | GitHub | Module |
|---|---|---|---|
| Rebecca Love Lianov Simanjuntak | 2506637110 | TBD | [Product Discovery](#product-discovery) |
| Aryan Alexander Rinaldi | 2506636895 | aryanalexander-cmyk | [Food of the Day](#food-of-the-day) |
| Muhammad Reyhan Attarizky | 2506637086 | REYHANCSUI25 | [Meal Plan](#meal-plan) |
| Alyssa Rahma Adjani | 2506558466 | alyssasaaa | [Product Comparison](#product-comparison) |
| Qeela Mufazzal Rafif Putra E | 2506637104 | qeela-mufazzal | [Blog](#blog) |
| Serafin Reysetyo Amantresno Grajo Pingol | 2506637136 | SPingol | [Profiles & Authentication](#profiles--authentication) |

## User Roles

| Role | Access |
|---|---|
| Guest | Browse products, preview comparisons, explore featured meals, and read published articles and comments. |
| Signed-in member | Manage a profile and dietary preferences, save items and comparisons, create meal plans, and participate in comments and Blog interactions. Personal records belong to the signed-in account. |
| Article author | Publish articles and edit or delete their own articles. |
| Staff | Delete articles when moderation is needed. |

## Flutter–Django Integration

Flutter uses the PWS deployment URL above as the base for the API paths below. A screen sends an HTTP request, reads the JSON response, and displays the returned products, recipes, articles, or account data. For example, the Comparison screen sends a barcode for each selected product. Django returns the products in order, the comparison rows, and any barcodes it could not load.

For account features, Flutter uses `CookieRequest` to keep the Django session after login. Requests to save a comparison, edit a profile, or open a personal meal plan use that session so Django can identify the owner. Django handles persistence and retrieves food or recipe data from Open Food Facts and Spoonacular where needed.

All paths below are relative to the PWS base URL. `GET /api/health/` is the public endpoint for checking that the API is reachable.

## Product Discovery

### Mobile Features in Scope

- Search by product name or browse popular products. Filter by grade, label, processing level, or ingredients and allergens to avoid.
- Open a product to see its SpoonFeed grade breakdown, nutrition, ingredients, and up to three better alternatives.
- Select products for side-by-side comparison. Signed-in members can also manage favorites and have viewed products recorded in their history.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/products/` | No | Search with `q` or browse popular products. Supports `grade`, `label`, `processing`, `avoid`, and `sort=grade`. |
| GET | `/api/products/<barcode>/` | No | Get product details and alternatives. Record the view when the user is signed in. |
| POST | `/api/products/<barcode>/favorite/` | Yes | Save or remove a favorite. Accepts `product_name` and returns the new `saved` state and a message. |

**Responses**

- `200` for a successful read or removal of a favorite. `201` when a new favorite is saved.
- `403` for a signed-out favorite request. `404` for an invalid or unknown barcode.
- `429` when search and detail exceed their shared limit of 60 requests per minute, or favorites exceed 30 requests per minute.
- `503` when Open Food Facts is unavailable and no cached result can be served.

**Django files** · `feat/products-api`

- Added `main/serializers.py`, `main/api_views.py`, and `main/api_urls.py`.
- Updated `midterm_project/urls.py` to register `/api/products/`.

## Food of the Day

### Mobile Features in Scope

- Browse today’s featured meal and up to six previous meals.
- Open a meal to see its recipe, nutrition, comments, and save state.
- Read comments, post a comment, and delete your own comments.
- Save a recipe snapshot, browse saved meals, or remove a bookmark.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/food-of-the-day/` | No | Get today’s featured meal and up to six previous meals. |
| GET | `/api/food-of-the-day/<meal_id>/` | No | Get recipe details, nutrition, comments, and save state. |
| GET | `/api/food-of-the-day/<meal_id>/comments/` | No | List comments for a meal. |
| POST | `/api/food-of-the-day/<meal_id>/comments/` | Yes | Post a comment using the `text` field. |
| DELETE | `/api/food-of-the-day/comments/<comment_id>/` | Yes | Delete a comment owned by the signed-in user. |
| POST | `/api/food-of-the-day/<meal_id>/save/` | Yes | Save a recipe snapshot or remove an existing bookmark. Returns the new `saved` state. |
| GET | `/api/food-of-the-day/saved/` | Yes | List the signed-in user’s saved meals and recipe snapshots. |

**Responses**

- `200` for reads, deleting a comment, or removing a bookmark. `201` when creating a comment or bookmark.
- `400` for invalid comment text. Signed-out users receive `401` when posting a comment and `403` on the other protected endpoints.
- `404` for a missing meal or a comment the user cannot delete. `429` when the same user repeats an identical comment on the same meal within ten seconds.
- If recipe data is unavailable, meal detail can still return `200` with `recipe: null` and an `error_message`.

**Django files** · `feat/meal-of-the-day-api`

- Added `food_of_the_day/serializers.py` and `food_of_the_day/api_views.py`.
- Updated `food_of_the_day/api_urls.py` with the feed, detail, comment, and bookmark routes.

## Meal Plan

### Mobile Features in Scope

- Create a plan using a name, start date, duration of 1–14 days, diets, allergies, optional snack, and calorie goal. The form starts with the member’s profile preferences.
- Browse personal plans and open a day to see meal photos, cooking times, calories, and macronutrients.
- Replace an individual meal with a suggested recipe. Rename, edit, or delete a plan.
- Browse recipes by search term, meal type, diet, maximum calories, and maximum cooking time.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/meal-plans/` | Yes | List the member’s meal plans. |
| POST | `/api/meal-plans/` | Yes | Create a plan using recipes selected from Spoonacular. |
| GET | `/api/meal-plans/form-options/` | Yes | Get diet and allergy choices, input limits, and profile defaults. |
| GET | `/api/meal-plans/recipes/` | Yes | Browse recipes using `q`, `meal`, `diet`, `max_calories`, `max_minutes`, and `page`. |
| GET | `/api/meal-plans/<id>/` | Yes | Open a plan with its day-by-day meals and recipe details. |
| PUT | `/api/meal-plans/<id>/` | Yes | Update all plan settings. Recipes are selected again only when needed. |
| PATCH | `/api/meal-plans/<id>/` | Yes | Update selected settings, such as the plan name. |
| DELETE | `/api/meal-plans/<id>/` | Yes | Delete a plan. |
| GET | `/api/meal-plans/<id>/meals/<meal_id>/options/` | Yes | Get replacement recipes. Use `round` for more suggestions. |
| POST | `/api/meal-plans/<id>/meals/<meal_id>/replace/` | Yes | Replace a meal by sending the suggested `recipe_id`. |

**Responses**

- `200` for successful reads and updates, `201` after creation, and `204` after deletion.
- `400` for invalid input, with field-level messages where applicable. `403` when signed out.
- `404` when a plan or meal is missing or belongs to another member.
- `503` when an operation requires Spoonacular and the service is unavailable or its quota is exhausted. An existing plan can still open with a recipe error message.

**Django files** · `feat/meal-plan-api`

- Added `meal_plan/serializers.py`, `meal_plan/api_views.py`, `meal_plan/api_urls.py`, and `meal_plan/test_api.py`.
- Updated `midterm_project/urls.py` to register `/api/meal-plans/`.

## Product Comparison

### Mobile Features in Scope

- Compare two or three distinct products side by side as a guest or signed-in member.
- Compare SpoonFeed grades, Nutri-Scores, Green-Scores, NOVA processing groups, nutrition per 100 g/ml, labels, and allergens.
- See the best available values highlighted per row. When a product cannot be loaded, see its barcode alongside the remaining results.
- Save a named lineup with optional notes. Reopen it with current product data, rename it, edit its notes, or delete it.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/comparisons/` | No | Preview two or three products. Repeat `barcode` for each product, e.g. `?barcode=001&barcode=002`. |
| GET | `/api/comparisons/saved/` | Yes | List the member’s saved comparisons, newest first. |
| POST | `/api/comparisons/saved/` | Yes | Save `name`, an ordered list of distinct barcode strings in `barcodes`, and optional `notes`. |
| GET | `/api/comparisons/saved/<id>/` | Yes | Reopen a saved lineup with its name, notes, and current comparison rows. |
| PATCH | `/api/comparisons/saved/<id>/` | Yes | Update `name`, `notes`, or both. |
| DELETE | `/api/comparisons/saved/<id>/` | Yes | Delete a saved comparison. |

**Responses**

- `200` for previews, lists, detail, and edits. Saving the same lineup in the same order again returns the existing record with `200`.
- `201` for a new save and `204` after deletion.
- `400` for invalid input or when a product needed for a new save cannot be loaded. A preview can return `200` with missing codes in `unavailable_barcodes`.
- `403` for signed-out access to saved comparisons or a failed browser CSRF check. `404` when the record is missing or belongs to another member.

**Django files** · `feat/comparison-api`

- Added `comparison/serializers.py`, `comparison/api_views.py`, `comparison/api_urls.py`, and `comparison/test_api.py`.
- Updated `midterm_project/urls.py` to register `/api/comparisons/`.

## Blog

### Mobile Features in Scope

- Browse, search, and filter the published article feed.
- Read articles and their comment threads. Authors can publish and manage their own articles.
- Post a top-level comment, reply to a comment, and like comments or replies.
- Save article snapshots, reopen them, and remove them from the saved list.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/blog/articles/` | No | Browse published articles using the optional `q`, `topic`, and `mine` filters. |
| POST | `/api/blog/articles/` | Yes | Create and publish an article. |
| GET | `/api/blog/articles/<slug>/` | No | Read the full article and its nested comments. |
| PUT, PATCH | `/api/blog/articles/<slug>/` | Yes · author | Update the article. |
| DELETE | `/api/blog/articles/<slug>/` | Yes · author or staff | Delete the article. |
| POST | `/api/blog/articles/<slug>/save/` | Yes | Save an article snapshot or remove it from the member’s saved list. |
| POST | `/api/blog/articles/<slug>/comments/` | Yes | Post a top-level comment or a single-level reply on a published article. |
| POST | `/api/blog/articles/<slug>/comments/<comment_id>/like/` | Yes | Set or toggle a like on a comment or reply. |
| GET | `/api/blog/saved/` | Yes | List the member’s saved article snapshots. |
| GET | `/api/blog/saved/<pk>/` | Yes | Read a specific saved snapshot. |
| DELETE | `/api/blog/saved/<pk>/` | Yes | Delete the snapshot and clean up its cover image file. |

**Responses** · TBD  
**Django files** · TBD

## Profiles & Authentication

### Mobile Features in Scope

- Register, log in, check session status, and log out.
- View and edit profile details and dietary preferences.
- Browse saved items by category and remove individual records.
- View item history and remove history entries.

### Django REST Framework Endpoints

| Method | Path | Login required | Description |
|---|---|---|---|
| GET | `/api/auth/` | No | List authentication and profile API URLs. |
| GET, POST | `/api/auth/login/` | No | GET checks session status. POST signs in with a username and password. |
| GET, POST | `/api/auth/register/` | No | GET returns diet and allergy choices. POST creates an account and profile. |
| GET, POST | `/api/auth/logout/` | No | GET checks session status. POST signs out. |
| GET, PUT, PATCH | `/api/auth/profile/` | Yes | Read profile details, dietary preferences, and derived API tags, or update the profile. |
| GET | `/api/auth/saved/` | Yes | List saved items. Filter with `category=all`, `product`, `comparison`, `article`, or `meal`. |
| POST, DELETE | `/api/auth/saved/<item_type>/<pk>/remove/` | Yes | Remove a saved product, comparison, article, or meal by type and ID. |

**Responses**

- `200` for successful reads, login, logout, profile updates, and saved-item removal. `201` after registration.
- `400` for invalid registration or profile data, or an unknown saved-item type.
- `401` for invalid login credentials. `403` when a signed-out user requests a protected endpoint.
- `404` when a saved item is missing or belongs to another member.

**Django files** · `feat/profiles-api`

- Added `profiles/serializers.py`, `profiles/api_views.py`, and `profiles/api_urls.py`.
- Updated `midterm_project/urls.py` to register `/api/auth/`.