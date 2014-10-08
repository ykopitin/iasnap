<?php /* @var $this Controller */ ?>
<?php $this->beginContent('//layouts/main1'); ?>
<div id="mainMbMenu">
    <?php $this->widget('application.extensions.mbmenu.MbMenu',array(
            'items'=>array(
                array('label'=>'Загальний інтерфейс порталу', 
				     'items'=>array(
                          array('label'=>'Пункти меню','url'=>array('/admin/genMenuItems/admin')),
                          array('label'=>'Посилання на статті до категорій сайту','url'=>array('/admin/genOtherInfo/admin')),
						  array('label'=>'Управління новинами','url'=>array('/admin/genNews/admin')),
						  array('label'=>'Відомості про нормативно-правові акти','url'=>array('/admin/genRegulations/admin')),
                      ),
				),
                array('label'=>'Послуги', 
                      'items'=>array(
                          array('label'=>'Відомості про центри та суб’єкти','url'=>array('/admin/genAuthorities/admin')),
                          array('label'=>'Відомості про послуги','url'=>array('/admin/genServices/admin')),
						  array('label'=>'Зв\'язок послуг з категоріями та класами','url'=>array('/admin/genServCatClass/admin')),
						  array('label'=>'Маршрути до послуг'),
						),
                ),
                array('label'=>'Користувачі',
				       'items'=>array(
                          array('label'=>'Ролі користувачів'),
                          array('label'=>'Внутрішні користувачі порталу'),
						  array('label'=>'Сертифікати внутрішніх користувачів'),
						  array('label'=>'Зовнішні користувачі порталу', 'url'=>array('/admin/CabUserExternal/admin')),
						  array('label'=>'Сертифікати зовнішніх користувачів'),
						  array('label'=>'Активність користувачів'),
						),
                ),
				array('label'=>'Довідники', 
				'items'=>array(
                          array('label'=>'Класи послуг','url'=>array('/admin/genServClasses/admin')),
                          array('label'=>'Категорії послуг','url'=>array('/admin/genServCategories/admin')),
						  array('label'=>'Зв\'язок категорій з класами','url'=>array('/admin/genCatClasses/admin')),
						  array('label'=>'Відомості про населені пункти','url'=>array('/admin/genLocations/admin')),
                   ),
				),
				array('label'=>'Вільні форми','url'=>array('/mff')),
            ),
    )); ?>
    </div><!-- mainmenu --> 
<div class="span-19">
	<div id="content">
		<?php echo $content; ?>
	</div><!-- content -->
</div>

<?php $this->endContent(); ?>