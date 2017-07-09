﻿
Процедура ИнициироватьЛокальныйРепозиторий( ЛокальныйРепозиторийАдрес ) Экспорт
	
	Если КаталогСодержитРепозиторий( ЛокальныйРепозиторийАдрес ) Тогда
		
		ВызватьИсключение "Каталог уже содержит репозиторий git";
		
	КонецЕсли;
	
	ТекстКоманды = "git init";
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при создании репозитория";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
		
	КонецЕсли;
	
	Config( ЛокальныйРепозиторийАдрес, "core.autocrlf", "false" );
	Config( ЛокальныйРепозиторийАдрес, "core.quotepath", "false" );
	
КонецПроцедуры

Процедура ДобавитьУдаленныйРепозиторий( ЛокальныйРепозиторийАдрес, УдаленныйРепозиторийАдрес ) Экспорт
	
	ТекстКоманды = "git remote add origin " + УдаленныйРепозиторийАдрес;
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при указании удаленного репозитория";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
		
	КонецЕсли;
	
КонецПроцедуры

Функция КаталогСодержитРепозиторий( ЛокальныйРепозиторийАдрес ) Экспорт
	
	МассивФайлов = НайтиФайлы( ЛокальныйРепозиторийАдрес, ".git" );
	
	Возврат МассивФайлов.Количество() > 0 И МассивФайлов[0].ЭтоКаталог();
	
КонецФункции

Процедура ОтслеживатьВсеФайлыВКаталоге( ЛокальныйРепозиторийАдрес, Каталог ) Экспорт
	
	ТекстКоманды = "git add -A .";
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при отслеживании файлов";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СконфигурироватьИмяПользователя( ЛокальныйРепозиторийАдрес, Имя ) Экспорт
	
	Config( ЛокальныйРепозиторийАдрес, "user.name", Имя, Истина );
	
КонецПроцедуры

Процедура СконфигурироватьEmailПользователя( ЛокальныйРепозиторийАдрес, Email ) Экспорт
	
	Config( ЛокальныйРепозиторийАдрес, "user.email", Email );
	
КонецПроцедуры


Процедура ВыполнитьИндексированиеИКоммит( Знач ЛокальныйРепозиторийАдрес,
										  Знач Комментарий,
										  Знач пДата,
										  Знач Хранилище ) Экспорт
	
	ДатаСтрокой = Формат( пДата, "ДФ=гггг-ММ-ддTЧЧ:мм:сс" );
	
	Если ПустаяСтрока( Комментарий ) Тогда
		
		Комментарий = "Комментарий не указан";
		
	КонецЕсли;
	
	ИмяФайлаКомментария = ПолучитьИмяВременногоФайла( "txt" );
	
	ФайлКомментария = Новый ЗаписьТекста( ИмяФайлаКомментария );
	ФайлКомментария.Записать( Комментарий );
	ФайлКомментария.Закрыть();
	
	вывод_Индекс = ПолучитьИмяВременногоФайла( "txt" );
	вывод_Коммит = ПолучитьИмяВременногоФайла( "txt" );
	
	командныйФайл_Индекс = ПолучитьИмяВременногоФайла( "bat" );
	
	записьТекста = Новый ЗаписьТекста( командныйФайл_Индекс, "cp866" );
	записьТекста.ЗаписатьСтроку( "chcp 866 >nul" );
	записьТекста.ЗаписатьСтроку( "set GIT_COMMITTER_DATE=" + ДатаСтрокой );
	записьТекста.ЗаписатьСтроку( "set GIT_AUTHOR_DATE=" + ДатаСтрокой );
	записьТекста.ЗаписатьСтроку( "git add -A . > " + Экранировать( вывод_Индекс ) );
	записьТекста.Закрыть();
	
	командныйФайл_Коммит = ПолучитьИмяВременногоФайла( "bat" );
	
	записьТекста = Новый ЗаписьТекста( командныйФайл_Коммит, "cp866" );
	записьТекста.ЗаписатьСтроку( "chcp 866 >nul" );
	записьТекста.ЗаписатьСтроку( "set GIT_COMMITTER_DATE=" + ДатаСтрокой );
	записьТекста.ЗаписатьСтроку( "set GIT_AUTHOR_DATE=" + ДатаСтрокой );
	записьТекста.ЗаписатьСтроку( "git commit -a --file=" + Экранировать( ИмяФайлаКомментария ) + " --date " + ДатаСтрокой + " > " + Экранировать( вывод_Коммит ) );
	записьТекста.Закрыть();
	
	ЛогВыводКоманды( "git add -A ." );
	
	КодВозврата = ВыполнитьКомандныйФайл( ЛокальныйРепозиторийАдрес, командныйФайл_Индекс );
	
	ЛогВыводКомандыИзФайла( вывод_Индекс );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при индексировании. Код возврата: " + КодВозврата;
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, командныйФайл_Индекс );
		
	КонецЕсли;
	
	УдалитьФайлы( командныйФайл_Индекс );
	
	ЛогВыводКоманды( "git commit -a --file=" + Экранировать( ИмяФайлаКомментария ) + " --date " + ДатаСтрокой );
	
	КодВозврата = ВыполнитьКомандныйФайл( ЛокальныйРепозиторийАдрес, командныйФайл_Коммит );
	
	ЛогВыводКомандыИзФайла( вывод_Коммит );
	
	Если КодВозврата <> 0 Тогда
		
		// Может быть ситуация, когда помещение в хранилище было, но даже сама 1С не видит изменений при выгрузке в файл.
		
		Если Не ПакетныйРежим.ПроверитьФайлИзменений_ЕстьИзменения( Хранилище ) Тогда
			
			Сообщить( "!!! Изменений нет. Коммит не выполнен" );
			
		Иначе
			
			ОписаниеОшибки = "Неизвестная ошибка при коммите. Код возврата: " + КодВозврата;
			ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, командныйФайл_Коммит );
			
		КонецЕсли;
		
	КонецЕсли;
	
	УдалитьФайлы( командныйФайл_Индекс );
	УдалитьФайлы( командныйФайл_Коммит );
	УдалитьФайлы( ИмяФайлаКомментария );
	
КонецПроцедуры


Процедура СохранитьСписокИзменений( Знач ЛокальныйРепозиторийАдрес, Знач Хранилище, Знач пВерсия ) Экспорт
	
	Config( ЛокальныйРепозиторийАдрес, "core.autocrlf", "false" );
	Config( ЛокальныйРепозиторийАдрес, "core.quotepath", "false" );
	
	командныйФайл     = ПолучитьИмяВременногоФайла( "bat" );
	имяФайлаИзменений = ПолучитьИмяВременногоФайла( "txt" );
	
	записьТекста = Новый ЗаписьТекста( командныйФайл, "cp866" );
	записьТекста.ЗаписатьСтроку( "git diff-tree --no-commit-id --name-only -r HEAD > " + имяФайлаИзменений );
	записьТекста.Закрыть();
	
	КодВозврата = ВыполнитьКомандныйФайл( ЛокальныйРепозиторийАдрес, командныйФайл );
	
	УдалитьФайлы( командныйФайл );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при получении изменений";
		Сообщить( ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, командныйФайл ) );
		
		Возврат;
	
	КонецЕсли;
	
	чтениеФайла = Новый ЧтениеТекста( имяФайлаИзменений, КодировкаТекста.UTF8 );
	
	текФайл = чтениеФайла.ПрочитатьСтроку();
	
	каталогКонфигурации = Справочники.Хранилища.ПолучитьКаталогКонфигурации( Хранилище );
	
	имяКаталога = СтрЗаменить( каталогКонфигурации, ЛокальныйРепозиторийАдрес, "" );
	
	Если ЗначениеЗаполнено( имяКаталога ) Тогда
		
		имяКаталога = СтрЗаменить( имяКаталога, "\", "/" );
		
		Если Не СтрЗаканчиваетсяНа( имяКаталога, "/" ) Тогда
			
			имяКаталога = имяКаталога + "/";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Пока текФайл <> Неопределено Цикл
		
		Если СтрНачинаетсяС( текФайл, имяКаталога )
			ИЛИ СтрНачинаетсяС( текФайл, """" + имяКаталога ) Тогда
			
			мз = РегистрыСведений.СписокИзменений.СоздатьМенеджерЗаписи();
			
			мз.ПутьКФайлу = Сред( текФайл, СтрДлина( имяКаталога ) + 1 );
			
			мз.Хранилище = Хранилище;
			мз.Версия    = пВерсия;
			
			мз.Записать();
			
		КонецЕсли;
		
		текФайл = чтениеФайла.ПрочитатьСтроку();
		
	КонецЦикла;
	
	чтениеФайла.Закрыть();
	
	УдалитьФайлы( имяФайлаИзменений );
	
КонецПроцедуры


Процедура Commit( ЛокальныйРепозиторийАдрес, Знач Комментарий, Дата, Хранилище ) Экспорт
	
	Если ПустаяСтрока( Комментарий ) Тогда
		
		Комментарий = "Комментарий не указан";
		
	КонецЕсли;
	
	ДатаСтрокой = Формат( Дата, "ДФ=гггг-ММ-ддTЧЧ:мм:сс" );
	
	ТекстКоманды = "git commit -m " + Экранировать( Комментарий ) + " --date " + ДатаСтрокой;
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		// Может быть ситуация, когда помещение в хранилище было, но даже сама 1С не видит изменений при выгрузке в файл.
		
		Если Не ПакетныйРежим.ПроверитьФайлИзменений_ЕстьИзменения( Хранилище ) Тогда
			
			Сообщить( "!!! Изменений нет. Коммит не выполнен" );
			
		Иначе
			
			ОписаниеОшибки = "Неизвестная ошибка при совершении комита. Код возврата: " + КодВозврата;
			ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Push( ЛокальныйРепозиторийАдрес ) Экспорт
	
	ТекстКоманды = "git push origin master";
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при отправлении изменений в удаленный репозиторий";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
		
	КонецЕсли;
	
КонецПроцедуры


Процедура Config( ЛокальныйРепозиторийАдрес, Параметр, Знач Значение, ЭкранироватьЗначение = Ложь )
	
	Если ЭкранироватьЗначение Тогда
		
		Значение = Экранировать( Значение );
		
	КонецЕсли;
	
	ТекстКоманды = "git config " + Параметр + " " + Значение;
	
	КодВозврата = ВыполнитьКоманду( ЛокальныйРепозиторийАдрес, ТекстКоманды );
	
	Если КодВозврата <> 0 Тогда
		
		ОписаниеОшибки = "Неизвестная ошибка при конфигурировании";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды );
		
	КонецЕсли;
	
КонецПроцедуры


Функция ИсключениеОшибкаПриВыполненииКоманды( ОписаниеОшибки, ТекстКоманды )
	
	Возврат ОписаниеОшибки + "(" + ТекстКоманды + ")";
	
КонецФункции


