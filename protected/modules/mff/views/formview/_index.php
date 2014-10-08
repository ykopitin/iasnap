<tr style="<?= ($index % 2) ? 'background:#fff9e0;' : 'background:#ffffff;' ?>"
    onclick="javascript:window.location='<?= $this->createUrl("indexstorage",array("id"=>$data->id)) ?>'" 
    onmouseout="javascript:this.style.background='<?= ($index % 2) ? "#fff9e0" : "#ffffff" ?>'"
    onmouseover="javascript:this.style.background='#66f9e0'">
    <td> <?= $data->id ?> </td>
    <td> <?= $data->name ?> </td>
    <td> <?= $data->description ?> </td>
</tr>