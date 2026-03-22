<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>PayPal JS SDK Standard Integration</title>
<script src="https://js.braintreegateway.com/web/dropin/1.46.0/js/dropin.min.js"></script>

<style>
 /* 전체 화면 덮는 로딩 오버레이 */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  font-size: 1.2rem;
  color: #333;
  visibility: hidden; /* 기본은 숨김 */
}

/* 로딩 중일 때 표시 */
body.loading .loading-overlay {
  visibility: visible;
}

/* 스피너 애니메이션 */
.spinner {
  border: 6px solid #f3f3f3;
  border-top: 6px solid #3498db;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
  margin-right: 15px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

	</style>
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
		<input type="hidden" id="customerId" name="customerId" value="sangbinlee9" />
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
			          document.body.classList.add("loading"); // CSS로 로딩 표시





			          // 3초 동안 로딩 화면을 보여주고 결제 요청 실행
			          setTimeout(() => {

				          dropinInstance.requestPaymentMethod().then((payload) => {
				              // Step four: when the user is ready to complete their transaction,
				              // use the dropinInstance to get a payment method nonce for the user's selected payment method,
				              // then add it a the hidden field before submitting the
				              // complete form to a server-side integration

				              console.log("■■■ requestPaymentMethod payload", payload);
				              document.getElementById('nonce').value = payload.nonce;
				              form.submit();
				          }).catch((error) => {

					        	    document.body.classList.remove("loading");
					        	    alert("결제 처리 중 오류가 발생했습니다. 다시 시도해주세요.");


					          console.error("■■■ requestPaymentMethod error", error);
				              throw error;
				          });
			          });





			      });
			  }).catch((error) => {
		          console.error("■■■ requestPaymentMethod error22222", error);
			      // handle errors
			  });
		  });

  	</script>
	<!-- 로딩 오버레이 -->
	<div class="loading-overlay">
		<div class="spinner"></div>
		<span>결제 처리 중입니다...</span>
	</div>

</body>
</html>
