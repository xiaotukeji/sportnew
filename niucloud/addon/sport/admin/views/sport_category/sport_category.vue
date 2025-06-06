<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportCategory') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportCategoryTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportCategoryTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('code')" prop="code">
                        <el-input v-model="sportCategoryTable.searchParam.code" :placeholder="t('codePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('icon')" prop="icon">
                        <el-input v-model="sportCategoryTable.searchParam.icon" :placeholder="t('iconPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('description')" prop="description">
                        <el-input v-model="sportCategoryTable.searchParam.description" :placeholder="t('descriptionPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('parentId')" prop="parent_id">
                        <el-input v-model="sportCategoryTable.searchParam.parent_id" :placeholder="t('parentIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('level')" prop="level">
                        <el-input v-model="sportCategoryTable.searchParam.level" :placeholder="t('levelPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('path')" prop="path">
                        <el-input v-model="sportCategoryTable.searchParam.path" :placeholder="t('pathPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportCategoryTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportCategoryTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportCategoryTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportCategoryTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportCategoryTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportCategoryList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportCategoryTable.data" size="large" v-loading="sportCategoryTable.loading">
                    <template #empty>
                        <span>{{ !sportCategoryTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="code" :label="t('code')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="icon" :label="t('icon')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="description" :label="t('description')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="parent_id" :label="t('parentId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="level" :label="t('level')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="path" :label="t('path')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportCategoryTable.page" v-model:page-size="sportCategoryTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportCategoryTable.total"
                        @size-change="loadSportCategoryList()" @current-change="loadSportCategoryList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportCategoryList, deleteSportCategory } from '@/addon/sport/api/sport_category'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportCategoryTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "code":"",
      "icon":"",
      "description":"",
      "parent_id":"",
      "level":"",
      "path":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取项目大类列表
 */
const loadSportCategoryList = (page: number = 1) => {
    sportCategoryTable.loading = true
    sportCategoryTable.page = page

    getSportCategoryList({
        page: sportCategoryTable.page,
        limit: sportCategoryTable.limit,
         ...sportCategoryTable.searchParam
    }).then(res => {
        sportCategoryTable.loading = false
        sportCategoryTable.data = res.data.data
        sportCategoryTable.total = res.data.total
    }).catch(() => {
        sportCategoryTable.loading = false
    })
}
loadSportCategoryList()

const router = useRouter()

/**
 * 添加项目大类
 */
const addEvent = () => {
    router.push('/sport_category/sport_category_edit')
}

/**
 * 编辑项目大类
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_category/sport_category_edit?id='+data.id)
}

/**
 * 删除项目大类
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportCategoryDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportCategory(id).then(() => {
            loadSportCategoryList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportCategoryList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
