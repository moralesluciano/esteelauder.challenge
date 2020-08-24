Estee Lauder challenge (http://agileengine.gitlab.io/interview/test-tasks/fsNDJmGOAwqCpzZx/)

To run the application

```
clone this repository
```
Then

```
$ cd my_app
$ docker container run --rm -v "$(pwd):/usr/src/app" -p 3000:3000 tekki/mojolicious morbo script/my_app
```

Browse to localhost:3000 and the app should show Money accounting system as a header.
For testing purposes use Postman or any similar app to either add or get transactions.

The following endpoint are defined:

POST: localhost:3000/urlapi/transactions/ (Commit new transaction to the account)
Body: Add this as JSON (application/json) choosing raw and add a body as following
{
  "type": "debit" (or credit),
  "amount": 1
}

GET: localhost:3000/urlapi/transactions/
Fetches transactions history

GET localhost:3000/urlapi/transactions/
Find transaction by ID

After adding at least one credit you should be able to see the transactions history list in the browser: localhost:3000

Some notes based on the requirements

Must have

1. Service must store the account value of the single user.
2. Service must be able to accept credit and debit financial transactions and update the account value correspondingly.
3. Any transaction, which leads to negative amount within the system, should be refused. Please provide http response code, which you think suits best for this case.

See the lib/Transactions.pm. When the user is not allowed to make a debit, the app retrieves a 400 error code and the message: "CAN NOT PROCESS THE OPERATION - BALANCE IS NOT ENOUGH". In this case, I think the FE side should show process the message and alert the user the issue.

4. Application must store transactions history. Use in-memory storage. Pay attention that several transactions can be sent at the same time. The storage should be able to handle several transactions at the same time with concurrent access, where read transactions should not lock the storage and write transactions should lock both read and write operations.

All the transactions are being stored in @transactions array (just because we want to show them in asc order). The lock logic is handle by lock_transaction, unlock_transaction and is_transaction_lock methods.

5. It is necessary to design REST API by your vision in the scope of this task. There are some API recommendations. Please use these recommendations as the minimal scope, to avoid wasting time for not-needed operations.

The endpoints are defined in script/my_app

UX/UI requirements

6. We need a simple UI application for this web service.
7. Please don't spend time for making it beautiful. Use a standard CSS library, like Bootstrap with a theme (or any other).

I took advantage of bootstrap to do that. I created the template into script/my_app to show the transactions since I ran into some issues with mojo when I tried to created that in a separate file. But, 

8. UI application should display the transactions history list only. No other operation is required.
9. Transactions list should be done in accordion manner. By default the list shows short summary (type and amount) for each transaction. Full info for a transaction should be shown on user's click.
10. It would be good to have some coloring for credit and debit transactions.

The credit actions will appear in green color and debit in red.
I would have liked to use angular to take advantage of data binding and update the page every time the transactions are updated instead of doing that manually clicking the refresh button of the browser, but I had 3 hours to complete the challenge. 

Unit test

I ran of time to write unit test and calculate the coverage, but I'd use a couple of packages that help me to handle that, for instance: Test::More, LWP::Simple and JSON. Then, I would have to create a method that take the method I want to test and the body to make the requests (setting the propers headers). Then, I should be able to start writting the unit tests for get and post endpoints created


