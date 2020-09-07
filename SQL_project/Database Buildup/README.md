# Sales Database Buildup

<br>

<p align="center">	
    <head>
        <b>The Schema of The Database</b>
    </head>
    <br></br>
	<img align="middle" width=800 height=600 src="database 2.png">
</p>

<br>



### 1. **Create tables:** 

Including `consumers`, `transactions`, `products`, `providers`, `categories`, `addresses`, `phones`. 

* **Creating Table `addresses` and Table `phones`:** 
  * Break down contact information into two tables to make data easier to understand, and allow a individual consumers to have multiple addresses or phone numbers. 
* **Set the primary key:** 
  * For each table, I create an `ID` variable and set it as the primary key to differentiate each row. 
* **Create name variables**: 
  * For each table except for the  `addresses` , `phones`, `orders` tables, I create a `name` variable and define it as `not null`, to make sure users can identify each row represents which consumer, factory or product.
* **Create variable `update_date`:**  
  * I create an `update_date` for each table, so users are able to check if data keep updating all the time. However, in the table `transactions` , I create a `transaction_date` variable to record a purchasing date for each transaction.

<br>

### 2. Dealing with One-to-many relationship:

For any two variables which belong to one-to-many relationship, I use foreign key to deal with the relationship:

* **In `transactions` table:**
  * To deal with a situation that an individual customer can have multiple transactions, I insert `ID_customer` with the foreign key from `customers` table in order to conveniently track who make those transactions.
  * A customer probably has several addresses or phone numbers but they only choose one of addresses as their shipping address in a single transaction, so I insert the variable  `shipping_address` and set is as a foreign key from the table `addresses`.
* **In `products` table:**
  * Since a provider may produce many products, I add the variable `ID_provider` with the foreign key from the table `providers`.
  * A category can include many different products, I create the variable `ID_category` with the foreign key from the table `categories` .
* **In `providers` table:**
  * Although a provider is supposed to possess only one address and one phone number, I still insert `ID_address` and `ID_phone` with the foreign keys from `addresses` table and `phones` table respectively, to ensure that we do not miss any contact information.

<br>

### 3. Dealing with Many-to-many relationship

For any two variables belong to many-to-many relationship, I create an entirely new table and include variables with foreign key to create connections between tables:

* * **Table `transactions_details`:** 
    * Because an order may include several products, and an individual product can exist in multiple orders, I begin a new table with variables `ID_transaction` and `ID_product` , which connect to the `orders` and `products` tables, respectively.
    * I set up a new variable `quantity` to recognize the quantity of a product for each order.
    * Product prices are likely to change anytime, and thus I create a new variable `price` to store the prices at the time of the transactions.

  * **Table `consumers_addresses` and Table`consumers_phones`: **
    * An individual customer probably hooks up multiple addresses or phone numbers. Even, consumers, such as a family,  may share the same address or the phone number. To address these situations,  I create two new tables and insert `ID_consumer`, `ID_address` and `ID_phone` with the foreign keys from the `consumers`, `addresses` and `phones` tables, respectively.

  * **Table `categories_providers`:**
    * A category can include many different providers, and a provider probably belongs to diverse categories as well, I build a new table and add variables, `ID_category` and `ID_provider`,  ith the foreign keys from the `categories` and `providers` tables, respectively.