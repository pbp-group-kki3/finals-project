# Spoonfed (Mobile)

## Application Description
Mobile companion app for the Spoonfed Django web application (`pbp-group-kki3/midterm-project`).

## Group Members
| Name | NPM | GitHub |
| :--- | :--- | :--- |
| Aryan Alexander Rinaldi | 2506636895 | aryanalexander-cmyk |
| Muhammad Reyhan Attarizky | 2506637086 | REYHANCSUI25 |

## Module Scoping & Ownership
| Module | Owner | Mobile Scope |
| :--- | :--- | :--- |
| Discover (`main`) | <Name> | Product search, filters, nutrition grading, product detail |
| Food of the Day (`food_of_the_day`) | Aryan | Daily meal feed, recipe details, comments, bookmark/save |
| Meal Plan (`meal_plan`) | Reyhan | View/create/edit/delete meal plans, replace meals, browse recipes |
| Comparison (`comparison`) | <Name> | Side-by-side product comparison, saved comparisons |
| Blog (`blog`) | <Name> | Read/create/edit articles, comments, likes, bookmarks |
| Profiles & Auth (`profiles`) | <Name> | Login, register, profile & dietary preferences, saved items |

## Django REST Framework Endpoints
Base URL: `<PWS Deployment URL>`

| Module | Method | Endpoint | Auth | Description |
| :--- | :--- | :--- | :--- | :--- |
| Health | `GET` | `/api/health/` | No | Verify DRF API status |
| Food of the Day | `GET` | `/api/food-of-the-day/` | No | List daily meals |
| Food of the Day | `GET` | `/api/food-of-the-day/<id>/` | No | Meal & recipe details + comments |
| Food of the Day | `POST` | `/api/food-of-the-day/<id>/comments/` | Yes | Add comment to meal |
| Food of the Day | `POST` | `/api/food-of-the-day/<id>/save/` | Yes | Toggle saved meal |
| Meal Plan | `GET` | `/api/meal-plans/` | Yes | List user's meal plans |
| Meal Plan | `POST` | `/api/meal-plans/` | Yes | Create meal plan |
| Meal Plan | `GET` | `/api/meal-plans/form-options/` | Yes | Plan form choices & profile defaults |
| Meal Plan | `GET` | `/api/meal-plans/recipes/` | Yes | Browse recipes with filters |
| Meal Plan | `GET` | `/api/meal-plans/<id>/` | Yes | Plan details + day-by-day meals |
| Meal Plan | `PUT` | `/api/meal-plans/<id>/` | Yes | Edit meal plan |
| Meal Plan | `PATCH` | `/api/meal-plans/<id>/` | Yes | Partially edit meal plan |
| Meal Plan | `DELETE` | `/api/meal-plans/<id>/` | Yes | Delete meal plan |
| Meal Plan | `GET` | `/api/meal-plans/<id>/meals/<meal_id>/options/` | Yes | Replacement options for a meal |
| Meal Plan | `POST` | `/api/meal-plans/<id>/meals/<meal_id>/replace/` | Yes | Replace meal with chosen recipe |

## Design & Release Links
- **Figma:** TBD
- **APK:** TBD
