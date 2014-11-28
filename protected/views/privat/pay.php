<?php
//echo CHtml::button('Âõ³ä çà ÅÖÏ',array('onclick'=>'return signd(); return false;')); 
?>

<form method="POST" accept-charset="utf-8" action="https://www.liqpay.com/api/pay">
<input type="hidden" name="public_key" value="i6289354858" />
<input type="hidden" name="amount" value="5" />
<input type="hidden" name="currency" value="UAH" />
<input type="hidden" name="description" value="posl1" />
<input type="hidden" name="type" value="buy" />
<input type="hidden" name="sandbox" value="1" />
<input type="hidden" name="pay_way" value="card,delayed" />
<input type="hidden" name="server_url" value="https://cnaptest.pp.ua/private/pay" />
<input type="hidden" name="order_id" value="1" />
<input type="hidden" name="language" value="ru" />
<input type="image" src="//static.liqpay.com/buttons/p1ru.radius.png" name="btn_text" />
</form>