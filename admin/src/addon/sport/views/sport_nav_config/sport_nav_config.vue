<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportNavConfig') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportNavConfigTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportNavConfigTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('icon')" prop="icon">
                        <el-input v-model="sportNavConfigTable.searchParam.icon" :placeholder="t('iconPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('selectedIcon')" prop="selected_icon">
                        <el-input v-model="sportNavConfigTable.searchParam.selected_icon" :placeholder="t('selectedIconPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('path')" prop="path">
                        <el-input v-model="sportNavConfigTable.searchParam.path" :placeholder="t('pathPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportNavConfigTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportNavConfigTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
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
                        <el-input v-model="sportNavConfigTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportNavConfigTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportNavConfigTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportNavConfigList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportNavConfigTable.data" size="large" v-loading="sportNavConfigTable.loading">
                    <template #empty>
                        <span>{{ !sportNavConfigTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="icon" :label="t('icon')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="selected_icon" :label="t('selectedIcon')" min-width="120" :show-overflow-tooltip="true"/>
                    
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
                    <el-pagination v-model:current-page="sportNavConfigTable.page" v-model:page-size="sportNavConfigTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportNavConfigTable.total"
                        @size-change="loadSportNavConfigList()" @current-change="loadSportNavConfigList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportNavConfigList, deleteSportNavConfig } from '@/addon/sport/api/sport_nav_config'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportNavConfigTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "icon":"",
      "selected_icon":"",
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
 * 获取导航配置列表
 */
const loadSportNavConfigList = (page: number = 1) => {
    sportNavConfigTable.loading = true
    sportNavConfigTable.page = page

    getSportNavConfigList({
        page: sportNavConfigTable.page,
        limit: sportNavConfigTable.limit,
         ...sportNavConfigTable.searchParam
    }).then(res => {
        sportNavConfigTable.loading = false
        sportNavConfigTable.data = res.data.data
        sportNavConfigTable.total = res.data.total
    }).catch(() => {
        sportNavConfigTable.loading = false
    })
}
loadSportNavConfigList()

const router = useRouter()

/**
 * 添加导航配置
 */
const addEvent = () => {
    router.push('/sport_nav_config/sport_nav_config_edit')
}

/**
 * 编辑导航配置
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_nav_config/sport_nav_config_edit?id='+data.id)
}

/**
 * 删除导航配置
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportNavConfigDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportNavConfig(id).then(() => {
            loadSportNavConfigList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportNavConfigList()
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
