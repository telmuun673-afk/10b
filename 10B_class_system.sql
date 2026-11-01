-- 10Б анги: оноо, өдрийн асуулт, дэлгүүр, өрөө
create table if not exists quiz_questions(
  id bigint generated always as identity primary key,
  cat text, q text not null, a text not null, b text not null, c text not null, d text not null,
  ans int not null check (ans between 1 and 4), expl text);
create table if not exists quiz_answers(
  student_id uuid not null, day date not null, qid bigint, choice int, correct boolean,
  created_at timestamptz default now(), primary key(student_id, day));
create table if not exists gift_claims(student_id uuid not null, day date not null, primary key(student_id, day));
create table if not exists shop_items(id text primary key, slot text not null, emoji text, name text, price int not null default 0);
create table if not exists purchases(student_id uuid not null, item_id text not null, primary key(student_id,item_id));
create table if not exists looks(student_id uuid primary key, base text default '🧑‍🎓', hat text, glass text, body text, wall text default 'wall_sky', room text[] default '{rm_bed}');
create table if not exists promo_codes(code text primary key, points int not null check (points>0), max_uses int not null default 1, note text, created_at timestamptz default now());
create table if not exists promo_uses(code text not null, student_id uuid not null, used_at timestamptz default now(), primary key(code,student_id));
alter table promo_codes enable row level security;
alter table promo_uses enable row level security;
alter table quiz_questions enable row level security;
alter table quiz_answers enable row level security;
alter table gift_claims enable row level security;
alter table shop_items enable row level security;
alter table purchases enable row level security;
alter table looks enable row level security;
drop policy if exists shop_read on shop_items;
create policy shop_read on shop_items for select using (true);

delete from quiz_questions where id>0 and not exists(select 1 from quiz_answers qa where qa.qid=quiz_questions.id);
insert into quiz_questions(cat,q,a,b,c,d,ans,expl) values
('Газар зүй','Өмнөд Солонгосын нийслэл аль вэ?','Сөүл','Пусан','Токио','Тайбэй',1,'Сөүл.'),
('Физик','Хүчний нэгж аль вэ?','Жоуль','Ньютон','Паскаль','Ватт',2,'Ньютон.'),
('Байгаль','Монголд аль нь “Улаан номонд” орсон ховор амьтан бэ?','Тахь (Пржевальскийн морь)','Үхэр','Хонь','Муур',1,'Тахь — Монголын ховор амьтан.'),
('Ерөнхий','Монгол Улсын мөнгөн тэмдэгтийн нэгж аль вэ?','Юань','Төгрөг','Рубль','Вон',2,'Төгрөг.'),
('Газар зүй','Дэлхийн хамгийн том далай аль вэ?','Атлантын далай','Энэтхэгийн далай','Номхон далай','Хойд Мөсөн далай',3,'Номхон далай.'),
('Ерөнхий','Монголын уламжлалт найр наадам ямар гурван төрлөөс бүрддэг вэ?','Бөх, морь, сур','Бөх, шатар, дуу','Морь, гар бөмбөг, сур','Хөгжим, бөх, бүжиг',1,'Эрийн гурван наадам.'),
('Биологи','Аль нь хөхтөн амьтан вэ?','Загас','Далайн гахай (дельфин)','Могой','Яст мэлхий',2,'Дельфин хөхтөн.'),
('Ерөнхий','Монголын Төрийн дуулал эхэлж ямар үгээр эхэлдэг вэ?','Дархан манай тусгаар улс','Хөх тэнгэр','Монгол эх орон','Алтан гэрэл',1,'“Дархан манай тусгаар улс...”'),
('Дэлхий','Египетийн алдарт пирамидууд аль тивд байдаг вэ?','Ази','Африк','Европ','Австрали',2,'Африк.'),
('Хими','Хүнсний давсны химийн томьёо аль вэ?','NaCl','KCl','CaCO3','H2SO4',1,'NaCl.'),
('Дэлхий','НҮБ-ын төв оффис аль хотод байдаг вэ?','Женев','Нью-Йорк','Лондон','Парис',2,'Нью-Йорк.'),
('Хими','Ургамал фотосинтезийн үед юуг шингээдэг вэ?','Хүчилтөрөгч','Нүүрсхүчлийн хий','Азот','Устөрөгч',2,'CO₂-г шингээж O₂ ялгаруулна.'),
('Ерөнхий','Анхны дэлхийн дайн хэдэн онд эхэлсэн бэ?','1905','1914','1939','1945',2,'1914 онд.'),
('Физик','Усны буцлах температур хэд вэ? (стандарт даралтад)','50°C','90°C','100°C','120°C',3,'100°C.'),
('Хэл','“Сайхан” үгийн эсрэг утгатай үг аль вэ?','Муухай','Сайн','Том','Хурдан',1,'Эсрэг утгатай үг.'),
('Түүх','Хубилай хаан Юань гүрнийг хэдэн онд байгуулсан бэ?','1206','1271','1368','1500',2,'1271 онд.'),
('Ерөнхий','Монголын уламжлалт хөгжмийн зэмсэг аль вэ?','Морин хуур','Гитар','Төгөлдөр хуур','Хийл',1,'Морин хуур.'),
('Математик','15% × 200 хэд вэ?','20','25','30','35',3,'200×0.15=30.'),
('Газар зүй','Монгол Улсын хамгийн том аймаг (талбайгаараа) аль вэ?','Өмнөговь','Хөвсгөл','Дорнод','Баянхонгор',1,'Өмнөговь аймаг.'),
('Байгаль','Монголын уулархаг нутагт амьдардаг “ирвэс” аль угсаатай вэ?','Муурын','Нохойн','Туулайн','Хонины',1,'Ирвэс — муурын овог.'),
('Түүх','Монгол Улс ардчилсан Үндсэн хуулиа хэдэн онд баталсан бэ?','1960','1980','1992','2000',3,'1992 оны Үндсэн хууль.'),
('Биологи','Хүний биед хэдэн яс байдаг вэ? (насанд хүрэгчид)','106','206','306','406',2,'206.'),
('Физик','Хүндийн хүчний үүсгэх хурдатгал дэлхий дээр ойролцоогоор хэд вэ?','1 м/с²','9.8 м/с²','98 м/с²','0.98 м/с²',2,'g ≈ 9.8 м/с².'),
('Математик','√81 хэд вэ?','7','8','9','10',3,'9×9=81.'),
('Математик','Тойргийн π тоо ойролцоогоор хэдтэй тэнцүү вэ?','2.14','3.14','4.13','3.41',2,'π ≈ 3.14159.'),
('Түүх','Монгол Улс НҮБ-д хэдэн онд элссэн бэ?','1946','1955','1961','1990',3,'1961 онд НҮБ-ын гишүүн болсон.'),
('Дэлхий','Дэлхийн хамгийн жижиг тив аль вэ?','Антарктид','Австрали','Европ','Өмнөд Америк',2,'Австрали.'),
('Ерөнхий','Цагаан сарын гол хоол аль вэ?','Банш','Өндөр шүүдэр (ул боов)','Бууз','Цуйван',2,'Ул боов, шагай, хонины шилэн мах.'),
('Газар зүй','Монголын хамгийн урт гол аль вэ?','Туул','Орхон','Хэрлэн','Сэлэнгэ',2,'Орхон гол, ойролцоогоор 1124 км.'),
('Газар зүй','Хэдэн тив байдаг вэ? (ихэнх сурах бичгээр)','5','6','7','8',3,'Ази, Африк, Хойд Америк, Өмнөд Америк, Антарктид, Европ, Австрали.'),
('Ерөнхий','Монголын таван хошуу мал юу вэ?','Тэмээ, хонь, үхэр, ямаа, адуу','Тахиа, гахай, хонь, ямаа, нохой','Хонь, ямаа, гахай, тахиа, нохой','Нохой, муур, адуу, ямаа, хонь',1,'Тэмээ, адуу, үхэр, хонь, ямаа.'),
('Хэл','“Hello” гэдгийг монголоор?','Сайн уу','Баяртай','Баярлалаа','Тийм',1,'Сайн уу.'),
('Астрономи','Дэлхий нарыг нэг удаа тойрч гарахад хэр хугацаа зарцуулдаг вэ?','1 сар','1 жил','1 өдөр','10 жил',2,'≈365 өдөр.'),
('Ерөнхий','Монгол Улсын төрийн далбаа ямар өнгөтэй вэ?','Улаан, цэнхэр, улаан','Улаан, цагаан, цэнхэр','Ногоон, шар, улаан','Цэнхэр, цагаан, шар',1,'Улаан-цэнхэр-улаан, голд нь соёмбо.'),
('Биологи','Вакцин юунаас хамгаалахад тусалдаг вэ?','Хүйтнээс','Халдварт өвчнөөс','Нар түлэхээс','Хоолны дуршлаас',2,'Халдварт өвчнөөс.'),
('Технологи','Wi-Fi юунд хэрэглэгддэг вэ?','Утасгүй интернэт холболт','Цахилгаан үүсгэх','Хоол халаах','Дуу бичих',1,'Утасгүй сүлжээ.'),
('Физик','Аль нь сэргээгддэг эрчим хүч вэ?','Нүүрс','Газрын тос','Нарны эрчим хүч','Байгалийн хий',3,'Нар, салхи, ус зэрэг.'),
('Түүх','Ардын хувьсгал хэдэн онд ялсан бэ?','1911','1921','1940','1961',2,'1921 оны 7-р сарын 11.'),
('Ерөнхий','Хоёрдугаар дэлхийн дайн хэдэн онд дууссан бэ?','1918','1939','1945','1950',3,'1945 онд.'),
('Дэлхий','Эйфелийн цамхаг аль хотод байдаг вэ?','Рим','Лондон','Парис','Мадрид',3,'Парис.'),
('Газар зүй','Монгол Улс аль хоёр улстай хиллэдэг вэ?','Орос, Хятад','Орос, Казахстан','Хятад, Өмнөд Солонгос','Япон, Хятад',1,'Хойд талаараа Орос, урд талаараа Хятад.'),
('Газар зүй','Монгол Улс хэдэн аймагтай вэ?','18','19','21','24',3,'21 аймаг, нийслэл Улаанбаатар.'),
('Математик','Зөв гурвалжны хажуу талууд 3 ба 4 бол гипотенуз хэд вэ?','5','6','7','12',1,'Пифагор: 3²+4²=5².'),
('Биологи','Цусыг биеэр эргүүлэн урсгадаг эрхтэн аль вэ?','Уушиг','Зүрх','Элэг','Бөөр',2,'Зүрх.'),
('Спорт','Сагсан бөмбөгийн багт талбай дээр нэг дор хэдэн тоглогч тоглодог вэ?','4','5','6','7',2,'Нэг талд 5.'),
('Спорт','Хөлбөмбөгийн багт талбай дээр нэг дор хэдэн тоглогч тоглодог вэ?','9','10','11','12',3,'Нэг талд 11.'),
('Технологи','Компьютерийн “тархи” гэж аль хэсгийг хэлдэг вэ?','CPU','Монитор','Гар','Хулгана',1,'Процессор.'),
('Спорт','Шатарт хаан хэдэн нүд алхаж чадах вэ?','1','2','3','Хязгааргүй',1,'Хаан нэг нүд.'),
('Математик','2 болон 5-ын хамгийн бага нийтлэг хуваагдагч (ХБНХ) хэд вэ?','7','10','20','25',2,'2 ба 5 харилцан анхны тул 2×5=10.'),
('Математик','Тэгш өнцөгтийн талууд 6 ба 4 бол талбай хэд вэ?','10','20','24','48',3,'6×4=24.'),
('Технологи','QR кодыг юунд ашигладаг вэ?','Холбоос, мэдээллийг камераар уншуулахад','Хоол хийхэд','Хөгжим сонсоход','Цаг хэмжихэд',1,'Камераар скан хийж мэдээлэл уншина.'),
('Физик','Цахилгаан гүйдлийн нэгж аль вэ?','Вольт','Ампер','Ватт','Ом',2,'Ампер.'),
('Технологи','1 байт хэдэн бит вэ?','4','8','16','10',2,'8 бит.'),
('Астрономи','Дэлхийн байгалийн дагуул аль вэ?','Сар','Ангараг','Ярилцагч','Фобос',1,'Сар.'),
('Хими','Алтны химийн тэмдэг аль вэ?','Ag','Au','Fe','Cu',2,'Au.'),
('Математик','12 × 12 хэд вэ?','124','132','144','154',3,'12×12=144.'),
('Математик','Квадратын 4 тал нь 5 см бол периметр хэд вэ?','10 см','15 см','20 см','25 см',3,'4×5=20.'),
('Газар зүй','Япон улсын нийслэл аль вэ?','Сөүл','Токио','Бээжин','Бангкок',2,'Токио.'),
('Газар зүй','Монголын хамгийн гүн нуур аль вэ?','Хөвсгөл нуур','Увс нуур','Хяргас нуур','Бүрэнхаан',1,'Хөвсгөл нуур, 262 м.'),
('Газар зүй','Монгол Улсын нийслэл аль вэ?','Дархан','Эрдэнэт','Улаанбаатар','Хөвсгөл',3,'Улаанбаатар.'),
('Газар зүй','Монголын говийн хамгийн алдартай нэг нь аль вэ?','Сахара','Гоби','Тар','Калахари',2,'Гоби.'),
('Түүх','Чингис хаан Их Монгол Улсыг хэдэн онд байгуулсан бэ?','1162','1206','1260','1368',2,'1206 онд Хуралдайгаар Чингис хаан хэмээн өргөмжлөгдсөн.'),
('Физик','Гэрлийн хурд ойролцоогоор хэд вэ?','300 км/с','3000 км/с','300000 км/с','3 сая км/с',3,'≈300 000 км/с.'),
('Хэл','“Цаг” үгийн ижил утгатай нь аль вэ?','Хугацаа','Хэмжээ','Өнгө','Дуу',1,'Ижил утгатай үг.'),
('Ерөнхий','Олимпын наадмыг хэдэн жил тутамд зохион байгуулдаг вэ?','2','3','4','5',3,'4 жил тутам.'),
('Биологи','Хүний ДНХ-ийн бүтэц ямар хэлбэртэй вэ?','Шулуун','Давхар мушгиа','Дугуй','Дөрвөлжин',2,'Давхар мушгиа.'),
('Математик','Хамгийн бага анхны тоо аль вэ?','0','1','2','3',3,'2 бол хамгийн бага анхны тоо.'),
('Ерөнхий','Интернэт веб хөтөч аль вэ?','Chrome','Word','Excel','Paint',1,'Chrome.'),
('Хэл','Аль нь нэр үг вэ?','Гэр','Гүйх','Хурдан','Ба',1,'Гэр — юмны нэр.'),
('Хэл','Монгол хэлэнд эгшиг хэдэн төрөлтэй вэ? (эрэгтэй, эмэгтэй, саармаг)','2','3','4','5',2,'Эр, эм, саармаг.'),
('Физик','Усны хөлдөх температур хэд вэ? (стандарт даралтад)','−10°C','0°C','4°C','32°C',2,'0°C.'),
('Газар зүй','Хамгийн олон хүн амтай тив аль вэ?','Африк','Ази','Европ','Хойд Америк',2,'Ази.'),
('Астрономи','Нарны аймгийн хамгийн том гариг аль вэ?','Санчир','Бархасбадь','Эрхэс','Дэлхий',2,'Бархасбадь.'),
('Математик','1 цагт хэдэн минут байдаг вэ?','30','60','90','100',2,'60 минут.'),
('Математик','Тойргийн радиус 5 бол диаметр хэд вэ?','5','10','15','25',2,'Диаметр=2×радиус.'),
('Хэл','Аль нь үйл үг вэ?','Номын сан','Уншина','Улаан','Маш',2,'Уншина — үйл үг.'),
('Хими','Агаарт хамгийн их агуулагддаг хий аль вэ?','Хүчилтөрөгч','Азот','Нүүрсхүчлийн хий','Аргон',2,'Азот (~78%).'),
('Хими','Усны химийн томьёо аль вэ?','CO2','H2O','O2','NaCl',2,'H₂O.'),
('Ерөнхий','Монгол Улс анх хэдэн онд зуны Олимпод оролцсон бэ?','1952','1964','1980','1992',2,'1964 онд Токиогийн Олимпод анх оролцсон.'),
('Газар зүй','Дэлхийн хамгийн өндөр уул аль вэ?','К2','Эверест','Килиманжаро','Монблан',2,'Эверест (Джомолунгма), ойролцоогоор 8849 м.'),
('Биологи','Ургамлын ногоон өнгийг юу өгдөг вэ?','Хлорофилл','Гемоглобин','Инсулин','Кальци',1,'Хлорофилл.'),
('Түүх','Монголын нийслэл Хархорум хотыг хэн байгуулсан бэ?','Хубилай хаан','Өгөдэй хаан','Мөнх хаан','Хүлэгү хаан',2,'1220-иод онд Чингис хаан сонгосон, Өгөдэй хаан хот байгуулсан.'),
('Хими','Хүчилтөрөгчийн тэмдэг аль вэ?','O','H','C','N',1,'O.'),
('Математик','10-ын 3 зэрэг (10³) хэд вэ?','30','100','1000','10000',3,'10×10×10=1000.'),
('Газар зүй','Монгол Улсын хамгийн өндөр оргил аль вэ?','Хайрхан','Хүйтэн оргил','Отгонтэнгэр','Таван богд',2,'Хүйтэн оргил, 4374 м.'),
('Физик','Дууны хурд агаарт ойролцоогоор хэд вэ?','34 м/с','340 м/с','3400 м/с','34000 м/с',2,'≈340 м/с.'),
('Дэлхий','Дэлхийн хамгийн их хүн амтай улс аль вэ? (одоогоор)','Хятад','Энэтхэг','АНУ','Индонез',2,'Энэтхэг саяхан Хятадыг гүйцсэн.'),
('Ерөнхий','Монгол хэл дээр хэдэн үсэг байдаг вэ? (кирилл)','33','35','36','40',2,'35 үсэг.'),
('Байгаль','Улаанбаатар хотын ойролцоох алдарт уул аль вэ?','Богд хан уул','Хайрхан','Алтай','Хангай',1,'Богд хан уул.'),
('Газар зүй','Франц улсын нийслэл аль вэ?','Лондон','Берлин','Парис','Мадрид',3,'Парис.'),
('Хэл','Англи хэлний “Thank you” монголоор яаж хэлэх вэ?','Баярлалаа','Сайн уу','Баяртай','Уучлаарай',1,'Баярлалаа.'),
('Математик','0.5 нь аль бутархайтай тэнцүү вэ?','1/4','1/3','1/2','2/3',3,'0.5=1/2.'),
('Астрономи','Улаан гариг гэж нэрлэдэг гариг аль вэ?','Ангараг','Санчир','Сугар','Тэнгэрийн ван',1,'Ангараг.'),
('Астрономи','Нарны аймагт хэдэн гариг байдаг вэ?','7','8','9','10',2,'8 гариг.'),
('Математик','Гурвалжны гурван өнцгийн нийлбэр хэд вэ?','90°','180°','270°','360°',2,'Гурвалжны өнцгийн нийлбэр 180°.'),
('Түүх','Монгол Улс тусгаар тогтнолоо хэдэн онд сэргээсэн бэ?','1911','1921','1924','1990',1,'1911 онд Богд хаант Монгол Улс байгуулагдсан.'),
('Байгаль','Монголд “Орхоны хөндий” аль цувралд багтдаг вэ?','ЮНЕСКО-гийн Дэлхийн өвд','Үндэсний цэцэрлэгт хүрээлэн','Хот','Аж ахуй',1,'ЮНЕСКО-гийн дэлхийн өв (Орхоны хөндийн соёлын ландшафт).'),
('Астрономи','Нарнаас хамгийн ойрхон гариг аль вэ?','Дэлхий','Сугар','Буд','Ангараг',3,'Буд (Mercury).'),
('Биологи','Хүний хамгийн том эрхтэн аль вэ?','Элэг','Арьс','Тархи','Гэдэс',2,'Арьс.'),
('Түүх','Монголын нууц товчоо ямар үйл явдлыг голчлон өгүүлдэг вэ?','Чингис хаан ба түүний удам угсаа','Манжийн эрхшээл','Хүннү гүрэн','Социализм',1,'13-р зууны Монголын түүхийн гол сурвалж.'),
('Ерөнхий','HTML юу вэ?','Вэб хуудас бичих хэл','Тоглоом','Хөтөч','Зураг засагч',1,'Вэб хуудсын тэмдэглэгээний хэл.');

insert into shop_items(slot,id,emoji,name,price) values
('hat','hat_cap','🧢','Кепка',50),
('hat','hat_top','🎩','Дээд малгай',60),
('hat','hat_hel','🪖','Дуулга',80),
('hat','hat_grad','🎓','Төгсөлтийн малгай',120),
('hat','hat_crown','👑','Титэм',300),
('hat','hat_phones','🎧','Чихэвч',90),
('glass','gl_sun','🕶️','Нарны шил',50),
('glass','gl_nerd','🤓','Мэдлэгийн шил',40),
('glass','gl_goggle','🥽','Хамгаалах шил',70),
('body','bd_scarf','🧣','Алчуур',30),
('body','bd_medal','🏅','Медаль',100),
('body','bd_tee','👕','Футболк',40),
('body','bd_coat','🧥','Пальто',120),
('wall','wall_sky','🌤️','Тэнгэр (үндсэн)',0),
('wall','wall_sunset','🌅','Нар жаргах',100),
('wall','wall_space','🌌','Сансар',150),
('wall','wall_forest','🌲','Ой',120),
('room','rm_bed','🛏️','Ор',0),
('room','rm_plant','🪴','Цэцэг',40),
('room','rm_books','📚','Номын тавиур',60),
('room','rm_game','🎮','Тоглоом',150),
('room','rm_pc','🖥️','Компьютер',200),
('room','rm_guitar','🎸','Гитар',120),
('room','rm_cat','🐱','Муур',180),
('room','rm_sofa','🛋️','Буйдан',250),
('room','rm_tv','📺','Зурагт',160)
on conflict (id) do update set slot=excluded.slot, emoji=excluded.emoji, name=excluded.name, price=excluded.price;

create or replace function _coins(sid uuid) returns int language sql stable security definer set search_path=public as $$
  select (
    (select count(*) from done d where d.student_id=sid)*10
   +(select count(*) from waterings w where w.student_id=sid)*5
   +(select count(*) from quiz_answers a where a.student_id=sid and a.correct)*10
   +(select count(*) from gift_claims g where g.student_id=sid)*20
   +coalesce((select sum(c.points) from promo_uses u join promo_codes c on c.code=u.code where u.student_id=sid),0)
   -coalesce((select sum(i.price) from purchases p join shop_items i on i.id=p.item_id where p.student_id=sid),0)
  )::int $$;

create or replace function wallet(p_code text) returns jsonb language plpgsql stable security definer set search_path=public as $$
declare sid uuid;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  return jsonb_build_object('coins',_coins(sid),'gift_today',exists(select 1 from gift_claims where student_id=sid and day=_today())); end $$;

create or replace function quiz_today(p_code text) returns jsonb language plpgsql security definer set search_path=public as $$
declare sid uuid; n int; qq quiz_questions; ar quiz_answers;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  select count(*) into n from quiz_questions; if n=0 then return null; end if;
  select * into qq from quiz_questions order by id offset ((_today() - date '2026-01-01') % n) limit 1;
  select * into ar from quiz_answers where student_id=sid and day=_today();
  return jsonb_build_object('id',qq.id,'cat',qq.cat,'q',qq.q,'opts',jsonb_build_array(qq.a,qq.b,qq.c,qq.d),
    'answered',ar.student_id is not null,'choice',ar.choice,'correct',ar.correct,
    'ans',case when ar.student_id is not null then qq.ans end,'expl',case when ar.student_id is not null then qq.expl end,
    'count',(select count(*) from quiz_answers where day=_today()),'right',(select count(*) from quiz_answers where day=_today() and correct));
end $$;

create or replace function quiz_answer(p_code text, p_choice int) returns jsonb language plpgsql security definer set search_path=public as $$
declare sid uuid; n int; qq quiz_questions; ok boolean;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  if p_choice not between 1 and 4 then raise exception 'bad choice'; end if;
  if exists(select 1 from quiz_answers where student_id=sid and day=_today()) then raise exception 'already'; end if;
  select count(*) into n from quiz_questions;
  select * into qq from quiz_questions order by id offset ((_today() - date '2026-01-01') % n) limit 1;
  ok := (p_choice=qq.ans);
  insert into quiz_answers(student_id,day,qid,choice,correct) values(sid,_today(),qq.id,p_choice,ok);
  return jsonb_build_object('correct',ok,'ans',qq.ans,'expl',qq.expl);
end $$;

create or replace function quiz_board() returns table(sname text, total bigint, today boolean, streak int)
language sql stable security definer set search_path=public as $$
  with d as (select student_id, day, day-(row_number() over(partition by student_id order by day))::int g from quiz_answers),
  gs as (select student_id, count(*) c, max(day) md from d group by student_id,g),
  st as (select student_id, max(c) filter (where md>=_today()-1) s from gs group by student_id)
  select s.name,
    (select count(*) from quiz_answers a where a.student_id=s.id and a.correct),
    exists(select 1 from quiz_answers a where a.student_id=s.id and a.day=_today() and a.correct),
    coalesce((select st.s from st where st.student_id=s.id),0)::int
  from students s where coalesce(s.is_admin,false)=false order by 2 desc, s.name $$;

create or replace function claim_gift(p_code text) returns boolean language plpgsql security definer set search_path=public as $$
declare sid uuid; r record;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  select * into r from duty_for(_today());
  if not found or (r.s1 is distinct from sid and r.s2 is distinct from sid) then return false; end if;
  insert into gift_claims(student_id,day) values(sid,_today()) on conflict do nothing;
  return true; end $$;

create or replace function my_inventory(p_code text) returns jsonb language plpgsql security definer set search_path=public as $$
declare sid uuid; l looks;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  insert into looks(student_id) values(sid) on conflict do nothing;
  select * into l from looks where student_id=sid;
  return jsonb_build_object('owned',coalesce((select jsonb_agg(item_id) from purchases where student_id=sid),'[]'::jsonb)
     || jsonb_build_array('wall_sky','rm_bed'),
    'look',to_jsonb(l)); end $$;

create or replace function buy_item(p_code text, p_item text) returns boolean language plpgsql security definer set search_path=public as $$
declare sid uuid; it shop_items;
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  select * into it from shop_items where id=p_item; if it.id is null then raise exception 'no item'; end if;
  if exists(select 1 from purchases where student_id=sid and item_id=p_item) or it.price=0 then return true; end if;
  if _coins(sid) < it.price then raise exception 'not enough coins'; end if;
  insert into purchases(student_id,item_id) values(sid,p_item);
  return true; end $$;

create or replace function equip_item(p_code text, p_slot text, p_item text) returns void language plpgsql security definer set search_path=public as $$
declare sid uuid; it shop_items; arr text[];
begin sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  insert into looks(student_id) values(sid) on conflict do nothing;
  if p_slot='base' then
    if p_item not in ('🧑‍🎓','👦','👧','🧑','🧒','😎') then raise exception 'bad base'; end if;
    update looks set base=p_item where student_id=sid; return; end if;
  if p_item is null or p_item='' then
    if p_slot='hat' then update looks set hat=null where student_id=sid;
    elsif p_slot='glass' then update looks set glass=null where student_id=sid;
    elsif p_slot='body' then update looks set body=null where student_id=sid; end if;
    return; end if;
  select * into it from shop_items where id=p_item and slot=p_slot; if it.id is null then raise exception 'bad item'; end if;
  if it.price>0 and not exists(select 1 from purchases where student_id=sid and item_id=p_item) then raise exception 'not owned'; end if;
  if p_slot='hat' then update looks set hat=p_item where student_id=sid;
  elsif p_slot='glass' then update looks set glass=p_item where student_id=sid;
  elsif p_slot='body' then update looks set body=p_item where student_id=sid;
  elsif p_slot='wall' then update looks set wall=p_item where student_id=sid;
  elsif p_slot='room' then
    select room into arr from looks where student_id=sid;
    if p_item=any(arr) then arr:=array_remove(arr,p_item); else arr:=array_append(arr,p_item); end if;
    update looks set room=arr where student_id=sid;
  end if; end $$;

create or replace function public_looks() returns table(sname text, base text, hat text, glass text, body text, wall text, room text[])
language sql stable security definer set search_path=public as $$
  select s.name, coalesce(l.base,'🧑‍🎓'), l.hat, l.glass, l.body, coalesce(l.wall,'wall_sky'), coalesce(l.room,'{rm_bed}')
  from students s left join looks l on l.student_id=s.id where coalesce(s.is_admin,false)=false $$;

create or replace function admin_make_code(p_code text, p_points int, p_max int, p_custom text, p_note text) returns text
language plpgsql security definer set search_path=public as $$
declare cd text;
begin
  if not coalesce(_adm(p_code),false) then raise exception 'admin only'; end if;
  if p_points is null or p_points<=0 or p_points>100000 then raise exception 'bad points'; end if;
  cd := upper(nullif(trim(coalesce(p_custom,'')),''));
  if cd is null then cd := upper(substr(md5(random()::text||clock_timestamp()::text),1,6)); end if;
  insert into promo_codes(code,points,max_uses,note) values(cd,p_points,greatest(coalesce(p_max,1),1),p_note);
  return cd;
end $$;

create or replace function redeem_code(p_code text, p_promo text) returns int
language plpgsql security definer set search_path=public as $$
declare sid uuid; pc promo_codes; cd text;
begin
  sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  cd:=upper(trim(coalesce(p_promo,'')));
  select * into pc from promo_codes where code=cd;
  if pc.code is null then raise exception 'Код буруу байна'; end if;
  if exists(select 1 from promo_uses where code=cd and student_id=sid) then raise exception 'Та энэ кодыг ашигласан байна'; end if;
  if (select count(*) from promo_uses where code=cd) >= pc.max_uses then raise exception 'Энэ кодын эрх дууссан'; end if;
  insert into promo_uses(code,student_id) values(cd,sid);
  return pc.points;
end $$;

create or replace function admin_list_codes(p_code text) returns table(code text, points int, max_uses int, used bigint, note text)
language plpgsql security definer set search_path=public as $$
begin
  if not coalesce(_adm(p_code),false) then raise exception 'admin only'; end if;
  return query select c.code,c.points,c.max_uses,(select count(*) from promo_uses u where u.code=c.code),c.note from promo_codes c order by c.created_at desc limit 30;
end $$;

-- чат мессежэнд reaction дарахад эзэнд мэдэгдэх
create or replace function toggle_reaction(p_code text, p_target text, p_id bigint, p_emoji text) returns boolean
language plpgsql security definer set search_path=public as $$
declare sid uuid; nm text; c int; au uuid;
begin
  sid:=_sid(p_code); if sid is null then raise exception 'bad code'; end if;
  if p_emoji not in ('❤️','😂','👍','😮','😢','🔥') then raise exception 'bad emoji'; end if;
  delete from reactions where target=p_target and target_id=p_id and student_id=sid and emoji=p_emoji;
  get diagnostics c = row_count;
  if c>0 then return false; end if;
  select name into nm from students where id=sid;
  insert into reactions(target,target_id,student_id,student_name,emoji) values(p_target,p_id,sid,nm,p_emoji);
  if p_target='ann' then select author_id into au from announcements where id=p_id;
  elsif p_target='comment' then select author_id into au from comments where id=p_id;
  elsif p_target='msg' then select student_id into au from messages where id=p_id; end if;
  if au is not null then perform _notify_one(au,sid,'react',p_emoji||' '||nm||' таны '||(case when p_target='ann' then 'зарлалд' when p_target='msg' then 'мессежэнд' else 'сэтгэгдэлд' end)||' reaction дарлаа',null,case when p_target='msg' then 'chat' else 'ann' end);
  end if;
  return true;
end $$;

grant execute on all functions in schema public to anon, authenticated;
