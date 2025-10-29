const fs = require('fs');

const file = 'src/addon/sport/pages/event/detail.vue';
const content = fs.readFileSync(file, 'utf-8');
const lines = content.split('\n');

// 追踪 view 标签的嵌套
let viewStack = [];
let inTemplate = false;

console.log('\n====== 查找未闭合的 <view> 标签 ======\n');

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNum = i + 1;
    
    // 检查是否进入/退出 template
    if (line.includes('<template>')) {
        inTemplate = true;
        continue;
    }
    if (line.includes('</template>')) {
        inTemplate = false;
        if (viewStack.length > 0) {
            console.log('\n❌ 在 </template> 处发现未闭合的 <view> 标签：');
            viewStack.forEach(item => {
                console.log(`   第 ${item.line} 行: ${item.content.trim()}`);
            });
        }
        break;
    }
    
    if (!inTemplate) continue;
    
    // 查找开标签（排除自闭合）
    const openMatches = line.match(/<view[^>]*(?<!\/)>/g);
    if (openMatches) {
        openMatches.forEach(match => {
            viewStack.push({ line: lineNum, content: line, tag: match });
        });
    }
    
    // 查找闭标签
    const closeMatches = line.match(/<\/view>/g);
    if (closeMatches) {
        closeMatches.forEach(() => {
            if (viewStack.length > 0) {
                viewStack.pop();
            } else {
                console.log(`⚠️ 第 ${lineNum} 行: 多余的 </view> 标签`);
            }
        });
    }
}

if (viewStack.length > 0) {
    console.log('\n❌ 发现未闭合的 <view> 标签：');
    viewStack.forEach(item => {
        console.log(`\n第 ${item.line} 行:`);
        console.log(`  ${item.content.trim()}`);
    });
    console.log(`\n总计：${viewStack.length} 个未闭合的 <view> 标签`);
} else {
    console.log('\n✅ 所有 <view> 标签都已正确闭合');
}

