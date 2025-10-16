# Mock Data Structure

This directory contains JSON files that provide mock data for the beauty app, replacing Firebase Firestore database and Sephora API integration.

## Files

### `categories.json`
Simple array of category names:
```json
[
  "Cleanser",
  "Moisturizer", 
  "Sunscreen",
  "Serum",
  "Toner",
  "Exfoliator",
  "Face Mask"
]
```

### `products.json`
Array of products with the following structure:
```json
{
  "id": 1,
  "name": "Product Name",
  "images": "assets/images/product-1.jpeg",
  "description": "Product description...",
  "price": 25.50,
  "rating": 4.5,
  "categories": "Cleanser",
  "ingredient": ["Ingredient 1", "Ingredient 2"],
  "skinType": "Oily, Combination",
  "bestFor": "Specific Skin Concern"
}
```

### `treatments.json`
Array of skincare treatments with detailed information:
```json
{
  "id": 1,
  "name": "Treatment Name",
  "price": 49.99,
  "duration": "4 weeks",
  "whatItIs": "Description of what the treatment is...",
  "whyItWorks": "Explanation of how it works...",
  "bestFor": "Target skin type",
  "results": "Expected results...",
  "skinConcern": "Main concern addressed",
  "recommendedProducts": [1, 5],
  "steps": [
    "Step 1: Instructions...",
    "Step 2: More instructions..."
  ]
}
```

## Key Features

### Product Data
- **8 Products** across 7 categories
- Real pricing ($8.99 - $25.50)
- Ratings from 4.2 - 4.8 stars
- Detailed ingredients list
- Skin type recommendations
- High-quality placeholder images

### Treatment Plans
- **4 Complete Treatment Plans**
- Target specific skin concerns (Acne, Dryness, Hyperpigmentation, Sun Protection)
- Step-by-step instructions
- Links to recommended products
- Duration and expected results

### Categories
- **7 Skincare Categories**
- Covers all essential skincare steps
- From basic cleansing to advanced treatments

## API Compatibility

The `ProductService` automatically converts this simplified format to match the original API structure, ensuring all existing UI code works without modification.

### Available Methods:
- `getProductsByCategory(categoryId)`
- `getCategories()`
- `searchProducts(query)`
- `getFeaturedProducts()`
- `getProductById(id)`
- `getProductDetails(id, sku)`
- `getTreatments()`
- `getTreatmentById(id)`
- `getTreatmentsByConcern(concern)`
- `getProductsForTreatment(treatmentId)`

## Adding New Data

### To add products:
1. Add to `products.json` with a unique `id`
2. Follow the existing structure
3. Use consistent category names

### To add categories:
1. Add to `categories.json` array
2. Ensure products use the exact category name

### To add treatments:
1. Add to `treatments.json` with unique `id`
2. Reference existing product IDs in `recommendedProducts`
3. Include detailed steps and information

## Testing

Use `ProductService.clearCache()` during development to refresh data after making changes to the JSON files.

The system includes automatic error handling and fallbacks if JSON files are missing or malformed.