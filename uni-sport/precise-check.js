const fs = require('fs');

const file = process.argv[2] || 'src/addon/sport/pages/event/detail.vue';
const content = fs.readFileSync(file, 'utf-8');
const lines = content.split('\n');

// 手动解析 template 部分的 view 标签
let inTemplate = false;
let viewStack = [];
let templateStart = -1;
let templateEnd = -1;

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const lineNum = i + 1;
    
    if (line.includes('<template>')) {
        inTemplate = true;
        templateStart = lineNum;
        continue;
    }
    if (line.includes('</template>')) {
        inTemplate = false;
        templateEnd = lineNum;
        break;
    }
    
    if (!inTemplate) continue;
    
    // 移除注释
    let processLine = line.replace(/<!--[\s\S]*?-->/g, '');
    
    // 查找自闭合的 view 标签（这些不需要闭合）
    processLine = processLine.replace(/<view[^>]*\/>/g, '');
    
    // 计数开标签
    let openCount = (processLine.match(/<view[\s>]/g) || []).length;
    let closeCount = (processLine.match(/<\/view>/g) || []).length;
    
    for (let j = 0; j < openCount; j++) {
        viewStack.push({ line: lineNum, content: line.trim() });
    }
    
    for (let j = 0; j < closeCount; j++) {
        if (viewStack.length > 0) {
            viewStack.pop();
        }
    }
    
    // 显示当前状态（仅当有变化时）
    if (openCount > 0 || closeCount > 0) {
        const indent = '  '.repeat(Math.max(0, viewStack.length));
        if (openCount > 0 && closeCount === 0) {
            // 只有开标签
           // console.log(`${lineNum}: ${indent}↓ [depth: ${viewStack.length}]`);
        } else if (closeCount > 0 && openCount === 0) {
            // 只有闭标签
            // console.log(`${lineNum}: ${indent}↑ [depth: ${viewStack.length}]`);
        }
    }
}

console.log(`\n模板区域: 第 ${templateStart} 行 到 第 ${templateEnd} 行`);
console.log(`\n检查结果:`);

if (viewStack.length > 0) {
    console.log(`\n❌ 发现 ${viewStack.length} 个未闭合的 <view> 标签：\n`);
    viewStack.forEach((item, index) => {
        console.log(`${index + 1}. 第 ${item.line} 行:`);
        console.log(`   ${item.content.substring(0, 100)}${item.content.length > 100 ? '...' : ''}`);
    });
    
    console.log(`\n建议: 在第 ${templateEnd - 1} 行的 </view> 之前添加 ${viewStack.length} 个 </view> 标签`);
} else if (viewStack.length < 0) {
    console.log(`\n❌ 有 ${Math.abs(viewStack.length)} 个多余的 </view> 闭合标签`);
} else {
    console.log(`\n✅ 所有 <view> 标签都已正确匹配`);
}

