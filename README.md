# diamondapp

lib/
├── bloc/
│   ├── diamond_filter_bloc.dart
│   ├── diamond_result_bloc.dart
│   └── cart_bloc.dart
├── data/
│   └── data.dart
├── model/
│   ├── diamond.dart
│   └── filter_params.dart
├── repositories/
│   ├── diamond_repository.dart
│   └── cart_repository.dart
├── screen/
│   ├── filter_page.dart
│   ├── result_page.dart
│   └── cart_page.dart
└── main.dart
 

State Management Logic
The application uses the BLoC (Business Logic Component) pattern for state management:
1. Filter BLoC

Purpose: Manages diamond filtering logic
States:

FilterInitial - Initial state with empty filters
FilterLoading - While filters are being applied
FilterLoaded - When filtered diamonds are available
FilterError - When an error occurs during filtering


Events:

SetFilter - Sets individual filter parameters
ClearFilters - Resets all filters
ApplyFilters - Applies the current filter set to the diamond dataset



2. Diamond BLoC

Purpose: Manages diamond listing and sorting logic
States:

DiamondsInitial - Initial state
DiamondsLoading - While diamonds are loading
DiamondsLoaded - When diamonds are loaded with current sort order
DiamondsError - When an error occurs


Events:

LoadDiamonds - Loads the diamond dataset
SortDiamondsByPrice - Sorts diamonds by price (asc/desc)
SortDiamondsByCarat - Sorts diamonds by carat weight (asc/desc)



3. Cart BLoC

Purpose: Manages cart state and persistence
States:

CartInitial - Initial empty cart state
CartLoading - While cart is loading from storage
CartLoaded - When cart is loaded with current items
CartError - When an error occurs during cart operations


Events:

LoadCart - Loads cart data from persistent storage
AddDiamondToCart - Adds a diamond to the cart
RemoveDiamondFromCart - Removes a diamond from the cart
ClearCart - Removes all diamonds from the cart


Persistent Storage Implementation
The app implements persistence using shared_preferences to maintain cart data across app restarts:
 
