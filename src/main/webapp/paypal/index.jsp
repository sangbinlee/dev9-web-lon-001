<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>PayPal JS SDK Standard Integration</title>
<script src="https://js.braintreegateway.com/web/dropin/1.46.0/js/dropin.min.js"></script>
</head>
<body>
	<ul>
		<li>add html tag, script</li>
		<li>Create a sandbox account</li>
		<li>Sandbox Keys & Configuration</li>
		<li>Merchant ID: 5wdg47wbvv8tc3qf</li>
		<li>Public Key: 4fxc4qxd4v26ykxg</li>
		<li>Private Key: 93984f2c3a953b38737a559438ac5a4e</li>
	</ul>
	<form id="payment-form" action="/lon/paypal" method="post">
		<!-- Putting the empty container you plan to pass to
		      'braintree.dropin.create' inside a form will make layout and flow
		      easier to manage -->
		<div id="dropin-container"></div>
		<input type="submit" />
		<input type="hidden" id="nonce" name="payment_method_nonce" />
<!-- 		<input type="hidden" id="customerId" name="customerId" value="sangbinlee9" /> -->
	</form>

	<script type="text/javascript">

		  const form = document.getElementById('payment-form');
		  var customerId = ''
// 			  customerId = document.getElementById('customerId').value;
		  fetch("/lon/paypal"+'?customerId=' + customerId)
		  .then(res => res.text())
		  .then(clientToken => {

			  console.log("■■■ call braintree.dropin.create code here");
			  braintree.dropin.create(
				{
			      authorization: clientToken,
			      container: '#dropin-container'
			  	}
			  ).then((dropinInstance) => {
			      // 이후 결제 처리 로직

				  console.log("■■■ dropinInstance", dropinInstance);

			      form.addEventListener('submit', (event) => {

					  console.log("■■■ form submit");

			          event.preventDefault();
			          dropinInstance.requestPaymentMethod().then((payload) => {
			              // Step four: when the user is ready to complete their transaction,
			              // use the dropinInstance to get a payment method nonce for the user's selected payment method,
			              // then add it a the hidden field before submitting the
			              // complete form to a server-side integration
			              document.getElementById('nonce').value = payload.nonce;
			              form.submit();
			          }).catch((error) => {
			              throw error;
			          });
			      });
			  }).catch((error) => {
			      // handle errors
			  });
		  });

  	</script>
</body>
</html>
