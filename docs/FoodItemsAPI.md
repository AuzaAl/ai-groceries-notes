please read this https://www.themealdb.com/documentation#v1

# TheMealDB API Specification V1 & V2 (Context AI Reference)

Comprehensive API reference schema for the TheMealDB recipe database designed for Context AI consumption, LLM system integration, and RAG architectures.

---

## 1. Global Configuration

### Base URLs

- **V1 (Standard Tier):** `https://www.themealdb.com/api/json/v1/`
- **V2 (Premium/Supporter Tier):** `https://www.themealdb.com/api/json/v2/`

### Authentication & Path Structure

Authentication is handled via path-based routing instead of request headers.

- **Free Development Key:** `1` (Rate-limited, core endpoints only)
- **Production/Supporter Key:** Replace `1` with your dedicated supporter key.

**Path Construction Pattern:**
`{Base URL}/{API Key}/{Endpoint}`

---

## 2. Core Schema Reference

### 2.1 Meal Object Schema (`meals[]`)

The structural payload returned by search, lookup, and random queries includes the following flat-key structure. Up to 20 ordered ingredient and measurement pairs are present.

| Field Name                    | Type   | Description                                               | Example                                    |
| :---------------------------- | :----- | :-------------------------------------------------------- | :----------------------------------------- |
| `idMeal`                      | String | Unique numeric identifier for the meal.                   | `"52772"`                                  |
| `strMeal`                     | String | Name/title of the recipe.                                 | `"Teriyaki Chicken Casserole"`             |
| `strDrinkAlternate`           | String | Alternative drink pairing or legacy field (nullable).     | `null`                                     |
| `strCategory`                 | String | Broad food classification category.                       | `"Chicken"`                                |
| `strArea`                     | String | Regional/National culinary origin.                        | `"Japanese"`                               |
| `strInstructions`             | String | Step-by-step textual cooking workflow.                    | `"Preheat oven... Cut chicken..."`         |
| `strMealThumb`                | String | Absolute secure URL to the high-resolution image asset.   | `"https://.../meals/llcbn01574260722.jpg"` |
| `strTags`                     | String | Comma-separated metadata tags (nullable).                 | `"Meat,Casserole"`                         |
| `strYoutube`                  | String | Absolute link to the video instructional guide.           | `"https://www.youtube.com/watch?v=..."`    |
| `strIngredient1` to `20`      | String | Textual name of individual ingredients (nullable).        | `"Soy Sauce"`, `""`                        |
| `strMeasure1` to `20`         | String | Corresponding volumetric/mass metrics (nullable).         | `"3/4 cup"`, `""`                          |
| `strSource`                   | String | Absolute fallback URL to original author/blog (nullable). | `"https://www.marscorner.com/..."`         |
| `strImageSource`              | String | Explicit copyright attribution link for image (nullable). | `null`                                     |
| `strCreativeCommonsConfirmed` | String | Creative Commons usage agreement validation (nullable).   | `null`                                     |
| `dateModified`                | String | Data revision tracking timestamp (nullable).              | `null`                                     |

---

## 3. API Endpoints Reference

### 3.1 Search & Discovery

#### Search Meal by Name

Queries full recipes matching a name pattern.

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/search.php?s={meal_name}`
- **Parameters:**
  - `s` (String, Required): Target search query.
- **Response Structure:** Array of detailed Meal Objects.

#### List Meals by First Letter

Optimized alpha index lookup.

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/search.php?f={letter}`
- **Parameters:**
  - `f` (Char, Required): Single alphanumeric letter (`a-z`).
- **Response Structure:** Array of detailed Meal Objects or `null` if no matches.

### 3.2 Single & Bulk Lookup

#### Lookup Full Meal Details by ID

Retrieves explicit payload record mapping to a known unique identifier.

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/lookup.php?i={id}`
- **Parameters:**
  - `i` (Integer/String, Required): Unique meal identifier (`idMeal`).
- **Response Structure:** Singular Array element with full object detail.

#### Lookup Single Random Meal

Returns one random recipe payload execution per request cycle.

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/random.php`
- **Parameters:** None
- **Response Structure:** Singular Array element with full object detail.

#### Lookup Random Selection (10 Meals)

_Requires Premium Tier Upgrade._

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v2/YOUR_API_KEY/randomselection.php`
- **Parameters:** None
- **Response Structure:** Array listing 10 randomized full Meal Objects.

#### Lookup Latest 10 Additions

_Requires Premium Tier Upgrade._

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v2/YOUR_API_KEY/latest.php`
- **Parameters:** None
- **Response Structure:** Array containing the 10 most recently added recipes.

---

### 3.3 Reference Metadata Lists

#### List Categories Details

Returns complete descriptive categories context mapping with images and summaries.

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/categories.php`
- **Payload Schema Attributes:** `idCategory`, `strCategory`, `strCategoryThumb`, `strCategoryDescription`.

#### Reference Enumeration Filtering Lists

Utility lists containing dictionary tokens across core data matrices.

- **Method:** `GET`
- **Endpoints:**
  - Categories: `https://www.themealdb.com/api/json/v1/1/list.php?c=list`
  - Areas/Nationalities: `https://www.themealdb.com/api/json/v1/1/list.php?a=list`
  - Ingredients Inventory: `https://www.themealdb.com/api/json/v1/1/list.php?i=list`

---

### 3.4 Filtering Operations

_Note: Filter endpoints return standard shallow metadata payloads containing three distinct identity targets: `strMeal`, `strMealThumb`, and `idMeal`._

#### Filter by Main Ingredient

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/filter.php?i={ingredient_name}`

#### Filter by Multiple Ingredients

_Requires Premium Tier Upgrade._

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v2/YOUR_API_KEY/filter.php?i={ing1,ing2,ing3}`
- **Parameters:** Comma-separated lower-snake-case list values.

#### Filter by Category

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/filter.php?c={category_name}`

#### Filter by Area

- **Method:** `GET`
- **URL Syntax:** `https://www.themealdb.com/api/json/v1/1/filter.php?a={area_name}`

---

## 4. Media Asset Utilities & Previews

The API allows direct parameter queries appended to asset links to serve varying optimized image resolutions.

### 4.1 Recipe Thumbnail Sizing Transformations

Append sizing targets cleanly onto explicit URL payloads parsed from `strMealThumb`:

- **Original Resolution Base:** `https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg`
- **Small Variant:** `https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg/small`
- **Medium Variant:** `https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg/medium`
- **Large Variant:** `https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg/large`

### 4.2 Ingredient Thumbnail Resolution Pipeline

Construct dynamic resource requests matching specific alphanumeric ingredients names formatted as lowercase strings separated by underscores (`{ingredient_name}.png`):

- **Base Endpoint:** `https://www.themealdb.com/images/ingredients/{ingredient_name}.png`
- **Example Resource Matrix:**
  - Small: `https://www.themealdb.com/images/ingredients/olive_oil.png/small`
  - Medium: `https://www.themealdb.com/images/ingredients/olive_oil.png/medium`
  - Large: `https://www.themealdb.com/images/ingredients/olive_oil.png/large
