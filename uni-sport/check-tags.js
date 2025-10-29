const fs = require('fs');

const file = process.argv[2] || 'src/addon/sport/pages/event/detail.vue';
const content = fs.readFileSync(file, 'utf-8');

// 统计各种标签
const tags = {
    'view': { open: 0, close: 0 },
    'text': { open: 0, close: 0 },
    'button': { open: 0, close: 0 },
    'image': { open: 0, close: 0 },
    'textarea': { open: 0, close: 0 },
    'switch': { open: 0, close: 0 }
};

// 统计开标签
for (const tag in tags) {
    const openRegex = new RegExp(`<${tag}[\\s>]`, 'g');
    const closeRegex = new RegExp(`</${tag}>`, 'g');
    
    tags[tag].open = (content.match(openRegex) || []).length;
    tags[tag].close = (content.match(closeRegex) || []).length;
}

console.log('\n====== Vue 文件标签检查 ======\n');
console.log('文件:', file);
console.log('总行数:', content.split('\n').length);
console.log('\n标签统计：');

let hasError = false;
for (const tag in tags) {
    const diff = tags[tag].open - tags[tag].close;
    const status = diff === 0 ? '✓' : '✗';
    console.log(`${status} <${tag}>: 开${tags[tag].open} 闭${tags[tag].close} 差${diff}`);
    if (diff !== 0) hasError = true;
}

// 检查三大区块
const templateMatch = content.match(/<template>/g);
const templateCloseMatch = content.match(/<\/template>/g);
const scriptMatch = content.match(/<script/g);
const scriptCloseMatch = content.match(/<\/script>/g);
const styleMatch = content.match(/<style/g);
const styleCloseMatch = content.match(/<\/style>/g);

console.log('\n结构标签：');
console.log(`${templateMatch?.length === templateCloseMatch?.length ? '✓' : '✗'} <template>: ${templateMatch?.length || 0} / ${templateCloseMatch?.length || 0}`);
console.log(`${scriptMatch?.length === scriptCloseMatch?.length ? '✓' : '✗'} <script>: ${scriptMatch?.length || 0} / ${scriptCloseMatch?.length || 0}`);
console.log(`${styleMatch?.length === styleCloseMatch?.length ? '✓' : '✗'} <style>: ${styleMatch?.length || 0} / ${styleCloseMatch?.length || 0}`);

if (hasError) {
    console.log('\n❌ 发现标签不匹配问题！');
    process.exit(1);
} else {
    console.log('\n✅ 所有标签匹配正常');
    process.exit(0);
}

