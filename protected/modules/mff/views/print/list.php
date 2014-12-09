Перелік документів (<?= count($model) ?>)
<table>
    <thead>
        <tr>
            <th>
                №
            </th>
            <th>
                Дата створення
            </th>
            <th>
                Реєстраційний №
            </th>
            <th>
                Дата реєстрації
            </th>
            <th>
                Організація
            </th>
            <th>
                ПІБ Заявника
            </th>
            <th>
                ДРФО Заявника
            </th>
            <th>
                ПІБ довіреної особи
            </th>
            <th>
                Номер довіреності
            </th>
            <th>
                Послуга
            </th>
            <th>
                Виконавчій орган
            </th>
            <th>
                Адміністратор
            </th>
            <th>
                Виконавець
            </th>
            <th>
                Контрольна дата
            </th>
            <th>
                Дата виконання
            </th>
        </tr>
    </thead>
<?php
Yii::import("mff.components.utils.tracknumberUtil");
foreach ($model as $modelItem) {
   ?>
    <tr>
        <td><?= tracknumberUtil::getTracknumberFromId($modelItem->id) ?></td>
        <td><?= $modelItem->getFieldValue("createdate") ?></td>
        <td><?= $modelItem->getFieldValue("regnum") ?></td>
        <td><?= $modelItem->getFieldValue("regdate") ?></td>
        <td><?= $modelItem->getFieldValue("organization_name") ?></td>
        <td><?= $modelItem->getFieldValue("person_name") ?></td>
        <td><?= $modelItem->getFieldValue("person_drfo") ?></td>
        <td><?= $modelItem->getFieldValue("autority_person_name") ?></td>
        <td><?= $modelItem->getFieldValue("autority_person_number") ?></td>
        <td><?= $modelItem->getFieldValue("service") ?></td>
        <td><?= $modelItem->getFieldValue("authorities") ?></td>
        <td><?= $modelItem->getFieldValue("administrator") ?></td>
        <td><?= $modelItem->getFieldValue("executor") ?></td>
        <td><?= $modelItem->getFieldValue("plandate") ?></td>
        <td><?= $modelItem->getFieldValue("factdate") ?></td>
    </tr>
    <?php
}
?>
</table>