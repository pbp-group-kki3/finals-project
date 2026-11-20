# Spoonfed (Mobile)

## Application Description
Mobile companion app for the Spoonfed Django web application (`pbp-group-kki3/midterm-project`).

## Group Members
| Name | NPM | GitHub |
| :--- | :--- | :--- |
| Aryan Alexander Rinaldi | 2506636895 | aryanalexander-cmyk |
| <Member 2> | <NPM> | <handle> |

## Module Scoping & Ownership
| Module | Owner | Mobile Scope |
| :--- | :--- | :--- |
| Discover (`main`) | <Name> | Product search, filters, nutrition grading, product detail |
| Food of the Day (`food_of_the_day`) | Aryan | Daily meal feed, recipe details, comments, bookmark/save |
| Meal Plan (`meal_plan`) | <Name> | View/create/edit meal plans, replace meals, browse recipes |
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

## Design & Release Links
- **Figma:** TBD
- **APK:** TBD
