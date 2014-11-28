

<?php
/**
* 1. Страница проверки данных плательщиком.
* 2. Формирование API 2.0 LiqPay для отправки на Ликпэй.
*/

/** Забираеем некоторые значения с предидущей страницы (из $_POST) **/
$amount = 5;
$description = "Posluga";

/** Выводим пользователю ранее введенные им данные (проверка). **/
echo '<p>
     <b>Сумма:</b>&nbsp;'. $amount . '&nbsp;$<br />
     <b>Назначение платежа:</b>&nbsp;' . $description . '<br />
     <b>e-mail:</b>&nbsp;  email  </p>';

/** Определение переменных для формы API 2.0 LiqPay **/
$order_id = date("d/m/Y-H:i:s");//id заказа
$merchant_id = 'i6289354858'; //ID мерчанта (прием платежей на карту/счет). Он же public_key
$private_key = "KvsOs9MOzY2qfE1aYDWu8RxgqnT88UjVSK6WnLZK"; //Подпись мерчанта
$return_url = 'https://cnaptest.pp.ua/privat/pay';     //страница на которую вернется клиент
$server_url = $return_url; //страница на которую прийдет ответ от сервера
$currency = 'UAH'; //Валюта
/*$order_id = array( // Берем необходимые значения платежа, для отсылки информации результата платежа (после платежа)
                    0 => date("d/m/Y_H:i:s"), //ID покупки в Вашем магазине. Должен быть УНИКАЛЬНЫМ для каждого платежа.
                    1 => $_POST['SenderMail'], //e-mail покупателя. Необходим для отсылки уведомления о статусе его платежа.
                    ); //print_r($order_id);
$order_id = implode('~', $order_id); *///преобразуем массив в строку
$order_id = "sdsw";
$type = 'buy';//buy - покупка, donate - пожертвование, subscribe - подписка
$sandbox = 0; //для теста-1, рабочий-0

/**
* Подпись запроса.
* Внимание!!!
* 1) Алгоритм формирования подписи, приведенный на https://www.liqpay.com/ru/doc#callback
*    как 'Проверка Callback сигнатуры' здесь не работает. При отправке запроса - просто НЕизвестны
*    переменные  status (статус платежа после оплаты), transaction_id (Id платежа в системе LiqPay),
*    sender_phone (номер телефона плательщика)
* 2) Также НЕ работает алгоритм - base64_encode(sha1(...));
*    Он закомментирован ниже
*/
$signature = base64_encode(sha1(join('',compact(
     'private_key',
     'amount',
     'currency',
     'merchant_id',
     'order_id',
     'type',
     'description',
     'return_url',
     'server_url'
)),1));

/** Нерабочий алгоритм **/
// $signature = base64_encode(sha1(
//          private_key .
//          amount .
//          currency .
//          merchant_id . //public_key .
//          order_id .
//          type .
//          description .
//          return_url .
//          server_url
// ,1));

/** Форма API 2.0 LiqPay **/
echo "1";
echo '<form id="liqpay" method="POST" action="https://www.liqpay.com/api/pay" accept-charset="utf-8">
          <input type="hidden" name="public_key" value="' . $merchant_id . '" />
          <input type="hidden" name="amount" value="' . $amount . '" />
          <input type="hidden" name="currency" value="' . $currency . '" />
          <input type="hidden" name="description" value="' . $description . '" />
          <input type="hidden" name="order_id" value="' . $order_id . '" />
          <input type="hidden" name="result_url" value="' . $return_url . '" />
          <input type="hidden" name="server_url" value="' . $server_url . '" /> 
          <input type="hidden" name="type" value="' . $type . '" />
          <input type="hidden" name="signature" value="' . $signature . '" />
          <input type="hidden" name="language" value="RU" />
          <input type="hidden" name="sandbox" value="' . $sandbox . '" />';
?>
     </form>

     <form id="back" action="javascript:history.back()">
          <!--это форма вспомогательная, для возврата назад--></form>

     <!--кнопка назад-->
          <button type="submit" form="back">Назад</button>&nbsp;&nbsp;
     <!--кнопка оплаты-->
          <button type="submit" form="liqpay">Оплатить LiqPay</button>

