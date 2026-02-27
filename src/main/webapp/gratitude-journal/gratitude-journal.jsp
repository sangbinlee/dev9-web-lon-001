<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세 줄 감사 일기 by Argo CD with k8s</title>
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <style>
        :root { --bg-color: #fdfaf5; --text-color: #4a4a4a; --accent: #8e9775; }
        body { font-family: sans-serif; background-color: var(--bg-color); color: var(--text-color); display: flex; flex-direction: column; align-items: center; padding: 20px; }
        .container { width: 100%; max-width: 400px; }
        .hidden { display: none; }
        .input-group { background: white; padding: 20px; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; }
        input { width: 100%; border: none; border-bottom: 1px solid #eee; padding: 10px 0; margin-bottom: 10px; outline: none; font-size: 1rem; }
        button { width: 100%; background: var(--accent); color: white; border: none; padding: 12px; border-radius: 10px; cursor: pointer; margin-top: 10px; }
        .diary-item { background: white; padding: 15px; border-radius: 12px; margin-bottom: 15px; border-left: 5px solid var(--accent); }
        .date { font-size: 0.8rem; color: #999; margin-bottom: 5px; }
    </style>
</head>
<body>

<div class="container">
    <h1>🌿 세 줄 감사 일기 (자동 배포 테스트 success ???????????????????)</h1>

    <div id="loginSection">
        <p style="text-align: center;">나만의 일기장을 클라우드에 저장하세요.</p>
        <button onclick="login()">구글 로그인으로 시작하기</button>
    </div>

    <div id="mainSection" class="hidden">
        <div class="input-group">
            <input type="text" id="line1" placeholder="첫 번째 감사">
            <input type="text" id="line2" placeholder="두 번째 감사">
            <input type="text" id="line3" placeholder="세 번째 감사">
            <button onclick="saveDiary()">오늘의 기록 저장</button>
        </div>
        <div id="diaryDisplay"></div>
        <button onclick="logout()" style="background:#ccc; font-size: 0.8rem;">로그아웃</button>
    </div>
</div>

<script>
    // 본인의 정보로 꼭 교체하세요!
    const SUPABASE_URL = 'https://ovzklkagyydsqmilstwp.supabase.co';//
    const SUPABASE_KEY = 'sb_publishable_pGHD353qE1iYb6LSRRkRdA_LluYLzAA';
//  승인된 리디렉션 URI
    const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

    // 구글 로그인 함수
    async function login() {
        await supabaseClient.auth.signInWithOAuth(
        	{
            	provider: 'google',
            	options: {
					redirectTo: 'https://diary.dev9.shop/lon/gratitude-journal/gratitude-journal.jsp'
				}
            }
        );
    }

    // 로그아웃 함수
    async function logout() {
        await supabaseClient.auth.signOut();
        location.reload();
    }

    // 일기 저장 함수
    async function saveDiary() {
        const { data: { user } } = await supabaseClient.auth.getUser();

        const l1 = document.getElementById('line1').value;
        const l2 = document.getElementById('line2').value;
        const l3 = document.getElementById('line3').value;

        if(!l1 || !l2 || !l3) return alert("세 줄을 다 적어주세요!");

        const { error } = await supabaseClient.from('Journal').insert([
            {
                user_id: user.id,
                line1: l1,
                line2: l2,
                line3: l3,
                date_str: new Date().toLocaleDateString()
            }
        ]);

        if (error) {
            alert("저장 실패: " + error.message);
        } else {
            alert("저장되었습니다!");
            location.reload(); // 새로고침해서 리스트 갱신
        }
    }

    // 일기 목록 불러오기 함수
    async function fetchDiaries(userId) {
        const { data, error } = await supabaseClient
            .from('Journal')
            .select('*')
            .eq('user_id', userId)
            .order('created_at', { ascending: false });

        if (data) {
            const display = document.getElementById('diaryDisplay');
            display.innerHTML = data.map(item => `
                <div class="diary-item">
                    <div class="date">\${item.date_str}</div>
                    <div>1. \${item.line1}</div>
                    <div>2. \${item.line2}</div>
                    <div>3. \${item.line3}</div>
                </div>
            `).join('');
        }
    }

    // 로그인 상태 감시 (페이지 열릴 때 자동 실행)
    supabaseClient.auth.onAuthStateChange((event, session) => {
        if (session) {
            document.getElementById('loginSection').classList.add('hidden');
            document.getElementById('mainSection').classList.remove('hidden');
            fetchDiaries(session.user.id);
        }
    });
</script>

</body>
</html>