-- 1. �������� ������, ������������ ������ ���� (������ firstname) ������������� ��� ���������� � ���������� �������. [ORDER BY]

SELECT DISTINCT firstname
FROM users
ORDER BY firstname;


-- 2. �������� ���������� ������ ������ 35 ��� [COUNT].

SELECT *
FROM profiles 
WHERE 
     TIMESTAMPDIFF(YEAR, birthday, NOW()) > 35
     AND gender = 'm'

-- 3. ������� ������ � ������ � ������ �������? (������� friend_requests) [GROUP BY]

SELECT 
	COUNT(*),
	status
FROM friend_requests 
GROUP BY status
 
-- 4.* �������� ����� ������������, ������� �������� ������ ���� ������ � ������ (������� friend_requests) [LIMIT].

SELECT 
	COUNT(*) AS cnt
FROM friend_requests 
GROUP BY initiator_user_id 
ORDER BY cnt DESC
LIMIT 1;

 
-- 5.* �������� �������� � ������ �����, ����� ������� ������� �� 5 �������� [LIKE].

SELECT name
FROM communities 
WHERE name LIKE '_____' -- 5 символов подчеркивания заменяют 5 букв
