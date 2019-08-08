# Currency converter

This is a currency converter that uses latest exchange rates against a reference currency (Euro).

Currency data sources
---------------------

The default source is the `Fixer API <https://fixer.io/>`_. The fixer API is powered by 15+ exchange rate data sources, the Fixer API is capable of delivering real-time exchange rate data for 170 world currencies. Endpoint functionalities include getting the latest exchange rate data for all or a specific set of currencies (All the end points are paid for except this), converting amounts from one currency to another, retrieving Time-Series data for one or multiple currencies and querying the API for daily fluctuation data. This is currently on the free plan.

Design Source
----------------

`Dribble https://dribbble.com/shots/6647815-Calculator`

Installation
------------

You can install directly after cloning: No additional set up is required.

Technology
-------------

 - Alamofire
 - SwiftyJSON
 - Charts
 - ActionSheetPicker-3.0

Fallbacks
~~~~~~~~~

This is currently on the free plan of the Fixer API which only get the latest rate against a reference currency (Euro). The graph shows random value because the Time-Series end point is under the paid plan.
